<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed, reactive, watch } from 'vue'
import SectionCard from '@/components/shared/SectionCard.vue'
import NumberStepper from '@/components/shared/NumberStepper.vue'
import RangeSlider from '@/components/shared/RangeSlider.vue'
import ColorPicker from '@/components/shared/ColorPicker.vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import type { HairValue } from '@/types'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const hair = computed(() => store.appearance?.hair)
const hairSettings = computed(() => store.settings?.hair)
const eyeColor = computed(() => store.appearance?.eyeColor ?? 0)
const eyeSettings = computed(() => store.settings?.eyeColor)

// Fade (ZONE_HAIR tattoo listesi)
const fadeItems = computed(() => store.settings?.tattoos?.items?.['ZONE_HAIR'] ?? [])
const currentFadeIndex = computed(() => {
  const zoneHair = store.appearance?.tattoos?.['ZONE_HAIR']
  if (!zoneHair?.length || !fadeItems.value.length) return 0
  const current = zoneHair[0]
  const idx = fadeItems.value.findIndex(
    (t: any) => t.name === current.name || (t.collection === current.collection && t.hashMale === current.hashMale)
  )
  return idx >= 0 ? idx : 0
})

const currentFadeOpacity = computed(() => {
  const zoneHair = store.appearance?.tattoos?.['ZONE_HAIR']
  if (!zoneHair?.length) return 1.0
  return zoneHair[0].opacity ?? 1.0
})

const automaticFade = computed(() => store.config?.automaticFade ?? false)

const local = reactive<HairValue>({
  style: 0,
  color: 0,
  highlight: 0,
  texture: 0,
})

watch(hair, (val) => {
  if (val) Object.assign(local, val)
}, { immediate: true, deep: true })

function applyHair() {
  store.changeHair({ ...local })
}

function setFade(val: number) {
  store.changeFade(val)
}

function setFadeOpacity(val: number) {
  store.changeFadeOpacity(val)
}

function setEyeColor(val: number) {
  store.changeEyeColor(val)
}
</script>

<template>
  <div class="space-y-2">
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-[14px] font-bold text-white uppercase tracking-widest font-display">
        {{ store.t('headOverlays.hair.title') }}
      </h2>
      <div class="flex items-center gap-2">
        <button
          class="px-3 py-1.5 rounded border transition-all duration-200 text-[10px] font-bold uppercase tracking-wider group flex items-center"
          :class="store.isFilterFavoritesActive ? 'text-white' : 'text-theme-text-muted hover:text-theme-text-primary'"
          :style="{
            backgroundColor: store.isFilterFavoritesActive ? 'var(--theme-accent)' : 'var(--theme-bg-card)',
            borderColor: store.isFilterFavoritesActive ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.2)'
          }"
          @click="store.isFilterFavoritesActive = !store.isFilterFavoritesActive"
          :title="store.isFilterFavoritesActive ? store.t('menu.showAll') : store.t('menu.showFavorites')"
        >
          <FaIcon 
            icon="star" 
            :size="16"
            class="mr-2" 
            :class="store.isFilterFavoritesActive ? 'text-white' : 'text-theme-accent'" 
          />
          {{ store.t('menu.favorites') }}
        </button>

        <button 
          class="px-3 py-1.5 rounded-lg border transition-all duration-300 text-[10px] font-black uppercase tracking-widest group flex items-center"
          :class="store.isPreloading ? 'text-white' : 'text-theme-text-muted hover:text-theme-text-primary'"
          :style="{
            backgroundColor: store.isPreloading ? 'rgba(239, 68, 68, 0.15)' : 'rgba(var(--theme-accent-rgb), 0.05)',
            borderColor: store.isPreloading ? 'rgba(239, 68, 68, 0.3)' : 'rgba(var(--theme-accent-rgb), 0.2)'
          }"
          @click="store.isPreloading ? store.stopPreload() : store.preloadAssets('hair')"
        >
          <FaIcon 
            :icon="store.isPreloading ? 'xmark' : 'cloud-arrow-down'" 
            :size="14"
            class="mr-2" 
            :class="!store.isPreloading ? 'text-theme-accent' : 'text-red-500'" 
          />
          {{ store.isPreloading ? (store.t('menu.cancelPreload')) : (store.t('menu.startPreload')) }}
        </button>
      </div>
    </div>

    <!-- Preload Progress Bar -->
    <div v-if="store.preloadProgress > 0" class="mb-6 rounded-theme-card bg-theme-card border border-white/5 overflow-hidden transition-all duration-300">
      <div class="px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <!-- Premium Icon Badge -->
          <div class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 bg-theme-card-hover border-none transition-all duration-300">
            <FaIcon icon="cloud-arrow-down" :size="14" class="text-theme-accent animate-pulse" />
          </div>
          <div class="flex flex-col">
            <h2 class="text-[12px] font-bold text-theme-accent uppercase tracking-widest font-display">
              {{ store.preloadItem }} {{ store.t('menu.loading') }}
            </h2>
            <span class="text-[9px] text-theme-text-muted uppercase font-bold tracking-tighter opacity-40">
              {{ store.t('menu.synchronizing') }}
            </span>
          </div>
        </div>
        <div class="flex flex-col items-end">
          <span class="text-[13px] font-black text-theme-text-primary tabular-nums tracking-wider">{{ store.preloadProgress }}%</span>
        </div>
      </div>
      
      <!-- Integrated Progress Track -->
      <div class="w-full h-[5px] bg-white/5 relative">
        <div 
          class="h-full bg-theme-accent transition-all duration-500 relative shadow-[0_0_15px_rgba(var(--theme-accent-rgb),0.8)]"
          :style="{ width: store.preloadProgress + '%' }"
        >
          <div class="absolute right-0 top-0 w-12 h-full bg-gradient-to-r from-transparent to-white/50"></div>
        </div>
      </div>
    </div>


    <!-- Hair Style -->
    <SectionCard :title="store.t('headOverlays.hair.style')" :icon="icons.hair.style" :default-open="true">
      <NumberStepper
        :label="store.t('headOverlays.hair.style')"
        v-model="local.style"
        :min="hairSettings?.style?.min ?? 0"
        :max="hairSettings?.style?.max ?? 77"
        @update:model-value="applyHair()"
      />
    </SectionCard>

    <!-- Hair Fade (ZONE_HAIR tattoo) — automaticFade=true ise gizle -->
    <SectionCard v-if="!automaticFade && fadeItems.length > 0" :title="store.t('headOverlays.hair.fade')" :icon="icons.hair.fade" :default-open="true">
      <NumberStepper
        :label="store.t('headOverlays.hair.fade')"
        :model-value="currentFadeIndex"
        :min="0"
        :max="fadeItems.length - 1"
        @update:model-value="setFade($event)"
      />
      <RangeSlider
        :label="store.t('headOverlays.opacity')"
        :model-value="currentFadeOpacity"
        :min="0.1"
        :max="1.0"
        :step="0.1"
        @update:model-value="setFadeOpacity($event)"
      />
    </SectionCard>

    <!-- Hair Color -->
    <SectionCard :title="store.t('headOverlays.hair.color')" :icon="icons.hair.color" :default-open="true">
      <ColorPicker
        v-if="hairSettings?.color?.items?.length"
        :label="store.t('headOverlays.hair.color')"
        :colors="hairSettings.color.items"
        v-model="local.color"
        @update:model-value="applyHair()"
      />
      <ColorPicker
        v-if="hairSettings?.highlight?.items?.length"
        :label="store.t('headOverlays.hair.highlight')"
        :colors="hairSettings.highlight.items"
        v-model="local.highlight"
        @update:model-value="applyHair()"
      />
    </SectionCard>

    <!-- Eye Color -->
    <SectionCard :title="store.t('headOverlays.eyeColor')" :icon="icons.hair.eyeColor" :default-open="true">
      <NumberStepper
        :label="store.t('headOverlays.eyeColor')"
        :model-value="eyeColor"
        :min="eyeSettings?.min ?? 0"
        :max="eyeSettings?.max ?? 30"
        @update:model-value="setEyeColor($event)"
      />
    </SectionCard>
  </div>
</template>
