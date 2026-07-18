<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { fetchNui } from '@/utils/nui'
import { ref } from 'vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import GameBlurCanvas from '@/components/layout/GameBlurCanvas.vue'
import { icons } from '@/config/icons'
import { useClothingToggles } from '@/composables/useClothingToggles'
import { useOrbitCamera } from '@/composables/useOrbitCamera'

const store = useAppearanceStore()
const { isUpperWorn, isLowerWorn, hatWasRemoved, maskWasRemoved, toggleUpper, toggleLower, toggleHat, toggleMask } = useClothingToggles()
const { resetOrbitOnly, exitOrbitMode, handleCameraPreset } = useOrbitCamera()

function toggleLight() {
  const opening = !store.isLightPanelOpen
  store.isLightPanelOpen = opening
  if (opening) {
    store.isOutfitsPanelOpen = false
    if (!store.lightConfig.active) {
      store.updateLightConfig({ active: true })
      fetchNui('appearance_toggle_light', { state: true, ...store.lightConfig })
    }
  } else {
    store.updateLightConfig({ active: false })
    fetchNui('appearance_toggle_light', { state: false, ...store.lightConfig })
  }
}

const isHandsUp = ref(false)
function toggleHandsUp() {
  isHandsUp.value = !isHandsUp.value
  if (isHandsUp.value) {
    fetchNui('appearance_play_animation', { dict: 'random@mugging3', name: 'handsup_standing_base', loop: true })
  } else {
    fetchNui('appearance_play_animation', { dict: 'reset', name: 'reset' })
  }
}

function rotateLeft() { resetOrbitOnly(); store.rotateLeft() }
function rotateRight() { resetOrbitOnly(); store.rotateRight() }
function turnAround() {
  resetOrbitOnly()
  if (isHandsUp.value) {
    isHandsUp.value = false
    fetchNui('appearance_play_animation', { dict: 'reset', name: 'reset' })
    return
  }
  store.turnAround()
}

// Tooltip always opens to the left of the right-side sidebar.
const tooltipClass = 'right-full mr-4'

defineExpose({ isHandsUp, rotateLeft, rotateRight, turnAround })
</script>

<template>
  <div 
    class="w-20 h-fit rounded-theme-panel border shadow-2xl pointer-events-auto flex flex-col py-6 gap-3 items-center shrink-0 relative z-50"
    :style="{ 
      borderColor: 'rgba(var(--theme-accent-rgb, 255, 255, 255), 0.1)',
      transform: 'translateZ(0)'
    }"
  >
    <!-- Clipped background layer (overflow-hidden clips GameBlurCanvas to panel's rounded corners) -->
    <div
      class="absolute inset-0 -z-10 pointer-events-none overflow-hidden"
      style="border-radius: inherit;"
    >
      <GameBlurCanvas style="position:absolute; inset:0; z-index:0;" />
      <div
        class="absolute inset-0 bg-theme-panel pointer-events-none"
        style="will-change: transform; transform: translateZ(0);"
      ></div>
    </div>


    <!-- Camera Preset Buttons -->
    <div class="flex flex-col gap-2 items-center">
      <button
        v-for="cam in ['head', 'body', 'bottom']"
        :key="cam"
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all relative group shrink-0 border"
        :style="{ 
          backgroundColor: 'transparent',
          borderColor: store.activeCamera === cam ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: store.activeCamera === cam ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="store.activeCamera === cam 
          ? 'text-theme-accent scale-105 shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="handleCameraPreset(cam)"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon :icon="icons.camera[cam as keyof typeof icons.camera]" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('camera.' + cam) }}
        </div>
      </button>
    </div>

    <div class="w-10 h-px bg-white/10 my-1"></div>

    <!-- Rotation Controls -->
    <div class="flex flex-col gap-2 items-center">
      <button
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{ 
          backgroundColor: 'transparent',
          borderColor: store.activeRotation === 'left' ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: store.activeRotation === 'left' ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="store.activeRotation === 'left' 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="rotateLeft()"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon :icon="icons.actions.rotateLeft" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('menu.rotateLeft') }}
        </div>
      </button>
      <button
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{ 
          backgroundColor: 'transparent',
          borderColor: store.activeRotation === 'right' ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: store.activeRotation === 'right' ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="store.activeRotation === 'right' 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="rotateRight()"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon :icon="icons.actions.rotateRight" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('menu.rotateRight') }}
        </div>
      </button>
      <button
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{ 
          backgroundColor: 'transparent',
          borderColor: store.activeRotation === 'turn' ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: store.activeRotation === 'turn' ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="store.activeRotation === 'turn' 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="turnAround()"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>


        <FaIcon icon="street-view" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('menu.turnAround') }}
        </div>
      </button>
    </div>

    <div class="w-10 h-px bg-white/10 my-1"></div>

    <!-- Clothing Toggles -->
    <div v-if="store.appearance" class="flex flex-col gap-2 items-center">
      <button
        v-if="store.config.componentConfig?.masks !== false"
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: maskWasRemoved ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: maskWasRemoved ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="maskWasRemoved 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="toggleMask"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="mask" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('components.mask') }}
        </div>
      </button>

      <button
        v-if="store.config.propConfig?.hats !== false"
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: hatWasRemoved ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: hatWasRemoved ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="hatWasRemoved 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="toggleHat"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="hat-cowboy" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('props.hats') }}
        </div>
      </button>

      <button
        v-if="store.config.componentConfig?.upperBody !== false"
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: !isUpperWorn ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: !isUpperWorn ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="!isUpperWorn 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="toggleUpper"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="shirt" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('components.upperBody') }}
        </div>
      </button>

      <button
        v-if="store.config.componentConfig?.lowerBody !== false"
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: !isLowerWorn ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: !isLowerWorn ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="!isLowerWorn 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="toggleLower"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="socks" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('components.lowerBody') }}
        </div>
      </button>
    </div>

    <div class="w-10 h-px bg-white/10 my-1"></div>

    <!-- Misc Toggles (Light/HandsUp/SwitchSide) -->
    <div v-if="store.appearance" class="flex flex-col gap-2 items-center">
      <button
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: store.isLightPanelOpen ? 'rgba(234, 179, 8, 0.5)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: store.isLightPanelOpen ? `inset 0 0 10px rgba(234, 179, 8, 0.3)` : 'none'
        }"
        :class="store.isLightPanelOpen 
          ? 'text-yellow-400 shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="toggleLight"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="lightbulb" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-yellow-500/20 rounded-lg text-[10px] font-bold text-yellow-400 uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('menu.toggleLight') }}
        </div>
      </button>

      <button
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: isHandsUp ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: isHandsUp ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="isHandsUp 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="toggleHandsUp"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="child-reaching" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('menu.toggleHandsUp') }}
        </div>
      </button>

      <div class="w-10 h-px bg-white/10 my-1"></div>

      <button
        class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all border group relative"
        :style="{
          backgroundColor: 'transparent',
          borderColor: store.isOutfitsPanelOpen ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
          boxShadow: store.isOutfitsPanelOpen ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
        }"
        :class="store.isOutfitsPanelOpen 
          ? 'text-theme-accent shadow-lg' 
          : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
        @click="store.isOutfitsPanelOpen = !store.isOutfitsPanelOpen; if(store.isOutfitsPanelOpen) store.isLightPanelOpen = false"
      >
        <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="border-radius: inherit; transform: translateZ(0);"></div>

        <FaIcon icon="clipboard" :size="18" />
        <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
          {{ store.t('menu.savedOutfits') }}
        </div>
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Tooltip fix: overflow:hidden on buttons clips absolute-positioned tooltips in CEF.
   Setting overflow:visible allows the tooltip to render outside the button bounds. */
button {
  overflow: visible;
}
/* Keep the inner background layer visually clipped inside the rounded card */
button > .\-z-10 {
  overflow: hidden;
  border-radius: inherit;
}
</style>
