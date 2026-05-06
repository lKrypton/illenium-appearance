<script setup lang="ts">
/**
 * GameBlurCanvas — FiveM CEF Frosted Glass (Two-Pass Separable Gaussian Blur)
 *
 * Pass 1 (horizontal): reads live game frame via FiveM magic hook, applies
 *   horizontal Gaussian blur, writes to an intermediate FBO texture.
 * Pass 2 (vertical): reads from FBO, applies vertical Gaussian blur, writes
 *   to the canvas.
 *
 * 25 samples per pass (±12, sigma≈18px) — smooth, artifact-free result.
 * UV coords come from getBoundingClientRect so only the panel area is shown.
 *
 * Reference: https://forum.cfx.re/t/how-to-use-x-cfx-game-view-cfxtexture/2270025
 */
import { ref, onMounted, onUnmounted, nextTick } from 'vue'

// blurStrength: sample step in pixels per pass (default 3.0)
// lower = softer/subtler, higher = stronger/more blur
const props = withDefaults(defineProps<{ blurStrength?: number }>(), { blurStrength: 1.0 })

const canvas = ref<HTMLCanvasElement>()
let animFrame = 0

// ── Pass 1 vertex: maps panel position to correct game-texture UV ────────────
const vertP1 = `
  attribute vec2 a_pos;
  varying   vec2 v_uv;
  uniform   vec2 u_uvOffset;
  uniform   vec2 u_uvScale;
  void main() {
    gl_Position = vec4(a_pos, 0.0, 1.0);
    vec2 n = (a_pos + 1.0) * 0.5;
    v_uv = u_uvOffset + n * u_uvScale;
  }
`

// ── Pass 2 vertex: reads full FBO texture (no offset needed) ─────────────────
const vertP2 = `
  attribute vec2 a_pos;
  varying   vec2 v_uv;
  void main() {
    gl_Position = vec4(a_pos, 0.0, 1.0);
    v_uv = (a_pos + 1.0) * 0.5;
  }
`

// ── Pass 1 fragment: horizontal Gaussian (25 samples, 3px step, sigma=18px) ──
const fragH = `
  precision mediump float;
  varying vec2 v_uv;
  uniform sampler2D u_tex;
  uniform float u_step;
  void main() {
    vec4  col  = vec4(0.0);
    float wsum = 0.0;
    float w;
    for (int i = -12; i <= 12; i++) {
      w     = exp(-float(i * i) / 72.0);
      col  += texture2D(u_tex, v_uv + vec2(float(i) * u_step, 0.0)) * w;
      wsum += w;
    }
    gl_FragColor = col / wsum;
  }
`

// ── Pass 2 fragment: vertical Gaussian (25 samples, 3px step, sigma=18px) ────
const fragV = `
  precision mediump float;
  varying vec2 v_uv;
  uniform sampler2D u_tex;
  uniform float u_step;
  void main() {
    vec4  col  = vec4(0.0);
    float wsum = 0.0;
    float w;
    for (int i = -12; i <= 12; i++) {
      w     = exp(-float(i * i) / 72.0);
      col  += texture2D(u_tex, v_uv + vec2(0.0, float(i) * u_step)) * w;
      wsum += w;
    }
    gl_FragColor = col / wsum;
  }
`

function makeShader(gl: WebGLRenderingContext, type: number, src: string) {
  const s = gl.createShader(type)!
  gl.shaderSource(s, src)
  gl.compileShader(s)
  const log = gl.getShaderInfoLog(s)
  if (log) console.warn('[GameBlur]', log)
  return s
}

function makeProgram(gl: WebGLRenderingContext, vSrc: string, fSrc: string) {
  const p = gl.createProgram()!
  gl.attachShader(p, makeShader(gl, gl.VERTEX_SHADER,   vSrc))
  gl.attachShader(p, makeShader(gl, gl.FRAGMENT_SHADER, fSrc))
  gl.linkProgram(p)
  return p
}

onMounted(async () => {
  await nextTick()
  const el = canvas.value
  if (!el) return

  const rect = el.getBoundingClientRect()
  el.width  = rect.width
  el.height = rect.height

  const gl = el.getContext('webgl', {
    antialias: false, depth: false, stencil: false,
    alpha: true, desynchronized: true,
    failIfMajorPerformanceCaveat: false,
  }) as WebGLRenderingContext | null
  if (!gl) { console.warn('[GameBlur] WebGL unavailable'); return }
  const ctx: WebGLRenderingContext = gl

  // ── Game-view texture — FiveM magic hook ─────────────────────────────────
  const gameTex = gl.createTexture()!
  gl.bindTexture(gl.TEXTURE_2D, gameTex)
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE,
    new Uint8Array([0, 0, 0, 0]))
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S,     gl.CLAMP_TO_EDGE)
  // Magic sequence — tells FiveM to stream live game frame into this texture
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT)
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
  gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)

  // ── FBO texture — intermediate storage between the two passes ────────────
  const fboTex = gl.createTexture()!
  gl.bindTexture(gl.TEXTURE_2D, fboTex)
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, el.width, el.height, 0, gl.RGBA,
    gl.UNSIGNED_BYTE, null)
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S,     gl.CLAMP_TO_EDGE)
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T,     gl.CLAMP_TO_EDGE)

  const fbo = gl.createFramebuffer()!
  gl.bindFramebuffer(gl.FRAMEBUFFER, fbo)
  gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, fboTex, 0)
  gl.bindFramebuffer(gl.FRAMEBUFFER, null)

  // ── Shader programs ───────────────────────────────────────────────────────
  const progH = makeProgram(gl, vertP1, fragH)
  const progV = makeProgram(gl, vertP2, fragV)

  // ── Shared quad geometry ──────────────────────────────────────────────────
  const buf = gl.createBuffer()!
  gl.bindBuffer(gl.ARRAY_BUFFER, buf)
  gl.bufferData(gl.ARRAY_BUFFER,
    new Float32Array([-1, -1,  1, -1,  -1, 1,  1, 1]), gl.STATIC_DRAW)

  function bindQuad(prog: WebGLProgram) {
    ctx.bindBuffer(ctx.ARRAY_BUFFER, buf)
    const loc = ctx.getAttribLocation(prog, 'a_pos')
    ctx.enableVertexAttribArray(loc)
    ctx.vertexAttribPointer(loc, 2, ctx.FLOAT, false, 0, 0)
  }

  // ── Cache uniform locations ───────────────────────────────────────────────
  const hTex = gl.getUniformLocation(progH, 'u_tex')
  const hOff = gl.getUniformLocation(progH, 'u_uvOffset')
  const hScl = gl.getUniformLocation(progH, 'u_uvScale')
  const hStp = gl.getUniformLocation(progH, 'u_step')
  const vTex = gl.getUniformLocation(progV, 'u_tex')
  const vStp = gl.getUniformLocation(progV, 'u_step')

  // ── UV params for Pass 1 (panel region → game texture UV) ────────────────
  // GL UV: Y=0 bottom, Y=1 top  vs  CSS: Y=0 top, Y=1 bottom → flip
  const uvOX = rect.left   / window.innerWidth
  const uvOY = 1.0 - rect.bottom / window.innerHeight
  const uvSX = rect.width  / window.innerWidth
  const uvSY = rect.height / window.innerHeight

  // blurStrength pixels per sample step in each direction
  const stepH = props.blurStrength / window.innerWidth
  const stepV = props.blurStrength / el.height

  gl.viewport(0, 0, el.width, el.height)

  // ── Render loop ───────────────────────────────────────────────────────────
  function render() {
    // Pass 1: horizontal blur — game texture → FBO
    ctx.bindFramebuffer(ctx.FRAMEBUFFER, fbo)
    ctx.useProgram(progH)
    bindQuad(progH)
    ctx.activeTexture(ctx.TEXTURE0)
    ctx.bindTexture(ctx.TEXTURE_2D, gameTex)
    ctx.uniform1i(hTex, 0)
    ctx.uniform2f(hOff, uvOX, uvOY)
    ctx.uniform2f(hScl, uvSX, uvSY)
    ctx.uniform1f(hStp, stepH)
    ctx.drawArrays(ctx.TRIANGLE_STRIP, 0, 4)

    // Pass 2: vertical blur — FBO → canvas
    ctx.bindFramebuffer(ctx.FRAMEBUFFER, null)
    ctx.useProgram(progV)
    bindQuad(progV)
    ctx.activeTexture(ctx.TEXTURE0)
    ctx.bindTexture(ctx.TEXTURE_2D, fboTex)
    ctx.uniform1i(vTex, 0)
    ctx.uniform1f(vStp, stepV)
    ctx.drawArrays(ctx.TRIANGLE_STRIP, 0, 4)
    ctx.finish()

    animFrame = requestAnimationFrame(render)
  }

  render()
})

onUnmounted(() => {
  cancelAnimationFrame(animFrame)
})
</script>

<template>
  <canvas
    ref="canvas"
    class="absolute inset-0 pointer-events-none"
    style="width: 100%; height: 100%;"
  />
</template>
