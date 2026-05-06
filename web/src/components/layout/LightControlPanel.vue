<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import FaIcon from '@/components/shared/FaIcon.vue'
import GameBlurCanvas from '@/components/layout/GameBlurCanvas.vue'

const store = useAppearanceStore()

const presets = [
  { name: 'Studio', r: 255, g: 255, b: 255, intensity: 10, distance: 2.5, height: 1.2 },
  { name: 'Warm', r: 255, g: 190, b: 100, intensity: 8, distance: 2.5, height: 1.0 },
  { name: 'Cool', r: 180, g: 220, b: 255, intensity: 12, distance: 3.0, height: 1.5 },
  { name: 'Neon', r: 255, g: 50, b: 255, intensity: 15, distance: 2.0, height: 0.8 },
]

function applyPreset(p: typeof presets[0]) {
  store.updateLightConfig(p)
}

function handleInput(key: string, val: any) {
  store.updateLightConfig({ [key]: val })
}

const DEFAULT_LIGHT = { r: 255, g: 255, b: 255, intensity: 10.0, distance: 2.5, angle: 0, height: 1.0 }
function resetDefaults() {
  store.updateLightConfig({ ...DEFAULT_LIGHT })
}
</script>

<template>
  <div 
    class="absolute bottom-0 w-72 rounded-theme-panel border shadow-2xl p-6 flex flex-col gap-7 pointer-events-auto transition-all duration-700 overflow-hidden right-full mr-4"
    :style="{ 
      borderColor: 'rgba(var(--theme-accent-rgb), 0.2)',
      boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.5)',
      transform: 'translateZ(0)'
    }"
  >
    <!-- Frosted Glass Blur -->
    <GameBlurCanvas style="z-index: -20;" />
    <!-- Stable Background Layer -->
    <div 
      class="absolute inset-0 bg-theme-panel -z-10 pointer-events-none"
      style="will-change: transform; transform: translateZ(0);"
    ></div>





    <div class="flex items-center gap-3 border-b border-white/10 pb-4">
      <div class="w-10 h-10 rounded-xl bg-theme-card border border-theme-accent-border flex items-center justify-center text-theme-accent shadow-inner">
        <FaIcon icon="wand-magic-sparkles" :size="18" />
      </div>
      <div class="flex flex-col">
        <h3 class="text-sm font-display font-bold text-theme-text-primary tracking-widest uppercase">
          {{ store.t('menu.lightSettings') || 'Studio Lighting' }}
        </h3>
        <span class="text-[9px] text-theme-text-muted uppercase tracking-tighter opacity-70">{{ store.t('menu.lightSubtitle') || 'Professional Lighting Rig' }}</span>
      </div>
    </div>

    <!-- Presets -->
    <div class="space-y-4">
      <div class="flex items-center gap-2">
        <div class="w-1 h-3 bg-theme-accent rounded-full"></div>
        <span class="text-[10px] font-bold text-theme-text-muted uppercase tracking-wider">{{ store.t('menu.lightPresets') || 'Quick Presets' }}</span>
      </div>
      <div class="grid grid-cols-2 gap-3">
        <button
          v-for="p in presets"
          :key="p.name"
          class="preset-btn px-4 py-2.5 rounded-theme-card border text-[11px] font-bold transition-all hover:scale-105 active:scale-95 shadow-sm relative overflow-hidden"
          :style="{
            '--preset-r': p.r,
            '--preset-g': p.g,
            '--preset-b': p.b,
            borderColor: 'rgba(' + p.r + ',' + p.g + ',' + p.b + ', 0.25)',
            color: 'rgb(' + Math.min(255, p.r+60) + ',' + Math.min(255, p.g+60) + ',' + Math.min(255, p.b+60) + ')'
          } as any"
          @click="applyPreset(p)"
        >
          <div class="preset-bg"></div>
          <span class="relative">{{ p.name }}</span>
        </button>

      </div>
    </div>

    <!-- Sliders -->
    <div class="space-y-6">
      <!-- Intensity -->
      <div class="space-y-3">
        <div class="flex justify-between items-center">
          <span class="text-[10px] font-bold text-theme-text-secondary uppercase tracking-tight">{{ store.t('menu.lightIntensity') || 'Intensity' }}</span>
          <span class="value-badge px-2 py-0.5 rounded text-[10px] font-mono text-theme-accent border border-theme-accent-border">
            {{ store.lightConfig.intensity.toFixed(1) }}
          </span>
        </div>
        <input 
          type="range" min="0" max="20" step="0.5" 
          v-model.number="store.lightConfig.intensity" 
          @input="handleInput('intensity', store.lightConfig.intensity)"
          class="w-full h-1.5 bg-white/5 rounded-full appearance-none cursor-pointer accent-theme-accent"
        />
      </div>

      <!-- Angle -->
      <div class="space-y-3">
        <div class="flex justify-between items-center">
          <span class="text-[10px] font-bold text-theme-text-secondary uppercase tracking-tight">{{ store.t('menu.lightRotation') || 'Rotation' }}</span>
          <span class="px-2 py-0.5 rounded bg-theme-accent/10 text-[10px] font-mono text-theme-accent border border-theme-accent-border">{{ store.lightConfig.angle }}°</span>
        </div>
        <input 
          type="range" min="-180" max="180" step="5" 
          v-model.number="store.lightConfig.angle" 
          @input="handleInput('angle', store.lightConfig.angle)"
          class="w-full h-1.5 bg-white/5 rounded-full appearance-none cursor-pointer accent-theme-accent"
        />
      </div>

      <!-- Height -->
      <div class="space-y-3">
        <div class="flex justify-between items-center">
          <span class="text-[10px] font-bold text-theme-text-secondary uppercase tracking-tight">{{ store.t('menu.lightHeight') || 'Height' }}</span>
          <span class="value-badge px-2 py-0.5 rounded text-[10px] font-mono text-theme-accent border border-theme-accent-border">
            {{ store.lightConfig.height.toFixed(1) }}m
          </span>
        </div>
        <input 
          type="range" min="-1" max="3" step="0.1" 
          v-model.number="store.lightConfig.height" 
          @input="handleInput('height', store.lightConfig.height)"
          class="w-full h-1.5 bg-white/5 rounded-full appearance-none cursor-pointer accent-theme-accent"
        />
      </div>

      <!-- Distance -->
      <div class="space-y-3">
        <div class="flex justify-between items-center">
          <span class="text-[10px] font-bold text-theme-text-secondary uppercase tracking-tight">{{ store.t('menu.lightDistance') || 'Distance' }}</span>
          <span class="value-badge px-2 py-0.5 rounded text-[10px] font-mono text-theme-accent border border-theme-accent-border">
            {{ store.lightConfig.distance.toFixed(1) }}m
          </span>
        </div>
        <input 
          type="range" min="0.5" max="5" step="0.1" 
          v-model.number="store.lightConfig.distance" 
          @input="handleInput('distance', store.lightConfig.distance)"
          class="w-full h-1.5 bg-white/5 rounded-full appearance-none cursor-pointer accent-theme-accent"
        />
      </div>
    </div>

    <!-- Reset Button -->
    <button
      class="reset-defaults-btn w-full h-9 flex items-center justify-center gap-2 rounded-theme-card text-[10px] font-bold uppercase tracking-widest border transition-all duration-200 hover:scale-[1.02] active:scale-95"
      @click="resetDefaults"
    >
      <FaIcon icon="rotate-left" :size="12" />
      {{ store.t('menu.restoreDefaults') || 'Reset Defaults' }}
    </button>
  </div>
</template>


<style scoped>
/* CEF GPU compositing fix: keep color layers on their own composited layer
   so Chromium does not re-rasterize them every frame (causes RGBA flicker). */
.preset-btn {
  background-color: transparent;
  transform: translateZ(0);
  backface-visibility: hidden;
  isolation: isolate;
  contain: layout paint;
  will-change: transform;
}
.preset-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: -1;
  background-color: rgba(var(--preset-r), var(--preset-g), var(--preset-b), 0.05);
  transform: translateZ(0);
  will-change: transform;
}

.value-badge {
  background-color: rgba(var(--theme-accent-rgb), 0.1);
  transform: translateZ(0);
  will-change: transform;
}

.reset-defaults-btn {
  color: rgba(var(--theme-accent-rgb), 0.6);
  border-color: rgba(var(--theme-accent-rgb), 0.2);
  background-color: rgba(var(--theme-accent-rgb), 0.05);
  transform: translateZ(0);
  will-change: transform;
}
.reset-defaults-btn:hover {
  color: rgb(var(--theme-accent-rgb));
  border-color: rgba(var(--theme-accent-rgb), 0.4);
  background-color: rgba(var(--theme-accent-rgb), 0.1);
}

input[type='range']::-webkit-slider-thumb {
  appearance: none;
  width: 12px;
  height: 12px;
  background: white;
  border-radius: 50%;
  border: 2px solid var(--theme-accent);
  box-shadow: 0 0 10px rgba(var(--theme-accent-rgb), 0.5);
}
</style>
