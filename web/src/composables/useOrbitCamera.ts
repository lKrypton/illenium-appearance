import { ref, onMounted, onUnmounted } from 'vue'
import { useAppearanceStore } from '@/stores/appearance'
import { fetchNui } from '@/utils/nui'

/**
 * Orbit Camera System (ported from illenium-appearance v1)
 * 
 * Enables free camera control by clicking/dragging on empty screen space:
 * - Click: starts orbit mode, camera focuses on nearest bone to cursor
 * - Drag: rotates camera around character (angleH / angleV)
 * - Scroll: zooms in/out (distance)
 * - Camera preset / rotation buttons: exit orbit mode first
 */
export function useOrbitCamera() {
  const store = useAppearanceStore()

  const orbitActive = ref(false)
  const isDragging  = ref(false)
  const orbitAngleH = ref(0)
  const orbitAngleV = ref(15)
  const orbitDist   = ref(2.2)

  const lastMouseX = ref(0)
  const lastMouseY = ref(0)

  function normCursor(e: MouseEvent | WheelEvent) {
    return {
      cursorX: e.clientX / window.innerWidth,
      cursorY: e.clientY / window.innerHeight,
    }
  }

  function startOrbitMode(cursorX: number, cursorY: number) {
    if (!orbitActive.value) {
      orbitActive.value = true
      store.activeCamera = 'default'
      fetchNui('appearance_start_orbit', { cursorX, cursorY })
    }
  }

  function exitOrbitMode() {
    if (!orbitActive.value) return
    orbitActive.value = false
    isDragging.value = false

    // Reset values so the next open starts clean
    orbitAngleH.value = 0
    orbitAngleV.value = 0
    orbitDist.value = 2.2

    fetchNui('appearance_exit_orbit')
  }

  // Resets JS orbit state locally without sending a NUI event.
  // Use before operations that already handle orbit exit on the Lua side
  // (rotateCamera, setCamera) to avoid double NUI calls that race each other.
  function resetOrbitOnly() {
    orbitActive.value = false
    isDragging.value = false
    orbitAngleH.value = 0
    orbitAngleV.value = 15
    orbitDist.value = 2.2
  }

  function updateOrbitLua(extra?: Record<string, unknown>) {
    fetchNui('appearance_update_orbit', {
      angleH: orbitAngleH.value,
      angleV: orbitAngleV.value,
      distance: orbitDist.value,
      ...extra,
    })
  }

  function handleOrbitMouseDown(e: MouseEvent) {
    if (!store.isVisible || !store.isReady) return
    if (e.button !== 0) return

    isDragging.value = true
    lastMouseX.value = e.clientX
    lastMouseY.value = e.clientY

    const { cursorX, cursorY } = normCursor(e)
    startOrbitMode(cursorX, cursorY)
    // Update focusZ from the bone system at drag start
    updateOrbitLua({ cursorX, cursorY, updateFocus: true })
  }

  function handleOrbitMouseMove(e: MouseEvent) {
    if (!isDragging.value) return

    const dx = e.clientX - lastMouseX.value
    const dy = e.clientY - lastMouseY.value

    orbitAngleH.value -= dx * 0.4
    orbitAngleV.value = Math.max(-10, Math.min(50, orbitAngleV.value + dy * 0.3))

    lastMouseX.value = e.clientX
    lastMouseY.value = e.clientY

    // focusZ does not change during drag (only angles update)
    updateOrbitLua()
  }

  function handleOrbitMouseUp() {
    isDragging.value = false
  }

  function handleOrbitWheel(e: WheelEvent) {
    if (!store.isVisible || !store.isReady) return
    e.preventDefault()

    if (!orbitActive.value) {
      const { cursorX, cursorY } = normCursor(e)
      startOrbitMode(cursorX, cursorY)
    }

    // Update zoom - focusZ never changes on scroll
    const delta = e.deltaY > 0 ? 0.15 : -0.15
    orbitDist.value = Math.max(0.5, Math.min(4.0, orbitDist.value + delta))
    updateOrbitLua() // updateFocus yok → focusZ sabit
  }

  function handleCameraPreset(cam: string) {
    // Only reset JS state; appearance_set_camera in Lua already calls cancelOrbit() + setCamera().
    // Sending appearance_exit_orbit separately would race with appearance_set_camera and block it.
    resetOrbitOnly()
    store.setCamera(cam)
  }

  // Global mouse listeners for drag tracking
  onMounted(() => {
    window.addEventListener('mousemove', handleOrbitMouseMove)
    window.addEventListener('mouseup', handleOrbitMouseUp)
  })

  onUnmounted(() => {
    window.removeEventListener('mousemove', handleOrbitMouseMove)
    window.removeEventListener('mouseup', handleOrbitMouseUp)
  })

  return {
    orbitActive,
    exitOrbitMode,
    resetOrbitOnly,
    handleOrbitMouseDown,
    handleOrbitWheel,
    handleCameraPreset,
  }
}
