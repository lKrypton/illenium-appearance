<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed } from 'vue'
import SectionCard from '@/components/shared/SectionCard.vue'
import NumberStepper from '@/components/shared/NumberStepper.vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const props2 = computed(() => store.appearance?.props ?? [])
const propSettings = computed(() => store.settings?.props ?? [])
const propConfig = computed(() => store.config.propConfig)

// prop_id → configKey mapping (from reference code)
const propItems: { id: number; configKey: string; localeKey: string; fallback: string; icon: string }[] = [
  { id: 0, configKey: 'hats', localeKey: 'props.hats', fallback: 'Hats', icon: icons.accessories.hats },
  { id: 1, configKey: 'glasses', localeKey: 'props.glasses', fallback: 'Glasses', icon: icons.accessories.glasses },
  { id: 2, configKey: 'ear', localeKey: 'props.ear', fallback: 'Earrings', icon: icons.accessories.ear },
  { id: 6, configKey: 'watches', localeKey: 'props.watches', fallback: 'Watches', icon: icons.accessories.watches },
  { id: 7, configKey: 'bracelets', localeKey: 'props.bracelets', fallback: 'Bracelets', icon: icons.accessories.bracelets },
]

// Filter by propConfig flags AND favorites if active
const visibleItems = computed(() => {
  const cfg = propConfig.value
  let items = propItems.filter((item) => (cfg as any)[item.configKey] !== false)

  // Apply Config.UI.Sections.accessories whitelist (and ordering) when defined
  const allowed = store.getVisibleSections('accessories')
  if (allowed) {
    const order = new Map(allowed.map((k, i) => [k, i]))
    items = items
      .filter(it => order.has(it.configKey))
      .sort((a, b) => (order.get(a.configKey)! - order.get(b.configKey)!))
  }

  if (store.isFilterFavoritesActive) {
    items = items.filter(item => {
      const favKey = `${store.appearance?.model}_prop_${item.id}`
      try {
        const data = JSON.parse(localStorage.getItem('illenium_favorites') || '{}')
        const favs = data[favKey] || []
        return favs.length > 0
      } catch {
        return false
      }
    })
  }
  return items
})

function getProp(propId: number) {
  return props2.value.find((p) => p.prop_id === propId)
}

function getSetting(propId: number) {
  return propSettings.value.find((s) => s.prop_id === propId)
}

function getLabel(item: typeof propItems[0]): string {
  return store.t(item.localeKey) || item.fallback
}

function updateDrawable(propId: number, drawable: number) {
  store.changeProp({ prop_id: propId, drawable, texture: 0 })
}

function updateTexture(propId: number, texture: number) {
  const prop = getProp(propId)
  if (prop) {
    store.changeProp({ prop_id: propId, drawable: prop.drawable, texture })
  }
}
</script>

<template>
  <div class="space-y-2">
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-[14px] font-bold text-white uppercase tracking-widest font-display">
        {{ store.t('props.title') || 'Accessories' }}
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
            :size="14"
            class="mr-2" 
            :class="store.isFilterFavoritesActive ? 'text-white' : 'text-theme-accent'" 
          />
          {{ store.t('menu.favorites') || 'Favorites' }}
        </button>

        <button 
          class="px-3 py-1.5 rounded-lg border transition-all duration-300 text-[10px] font-black uppercase tracking-widest group flex items-center"
          :class="store.isPreloading ? 'text-white' : 'text-theme-text-muted hover:text-theme-text-primary'"
          :style="{
            backgroundColor: store.isPreloading ? 'rgba(239, 68, 68, 0.15)' : 'rgba(var(--theme-accent-rgb), 0.05)',
            borderColor: store.isPreloading ? 'rgba(239, 68, 68, 0.3)' : 'rgba(var(--theme-accent-rgb), 0.2)'
          }"
          @click="store.isPreloading ? store.stopPreload() : store.preloadAssets('props')"
        >
          <FaIcon 
            :icon="store.isPreloading ? 'xmark' : 'cloud-arrow-down'" 
            :size="14"
            class="mr-2" 
            :class="!store.isPreloading ? 'text-theme-accent' : 'text-red-500'" 
          />
          {{ store.isPreloading ? (store.t('menu.cancelPreload') || 'Cancel') : (store.t('menu.startPreload') || 'Preload') }}
        </button>
      </div>
    </div>

    <!-- Preload Progress Bar -->
    <div v-if="store.preloadProgress > 0" class="mb-6 rounded-theme-card bg-theme-card border border-white/5 overflow-hidden transition-all duration-300">
      <div class="px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <!-- Premium Icon Badge -->
          <div class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 bg-theme-card-hover transition-all duration-300">
            <FaIcon icon="cloud-arrow-down" :size="14" class="text-theme-accent" />
          </div>
          <div class="flex flex-col">
            <h2 class="text-[12px] font-bold text-theme-accent uppercase tracking-widest font-display">
              {{ store.preloadItem }} {{ store.t('menu.loading') || 'LOADING' }}
            </h2>
            <span class="text-[9px] text-theme-text-muted uppercase font-bold tracking-tighter opacity-40">
               {{ store.t('menu.synchronizing') || 'System Synchronizing Assets...' }}
            </span>
          </div>
        </div>
        <div class="flex flex-col items-end">
          <span class="text-[13px] font-black text-theme-text-primary tabular-nums tracking-wider">{{ store.preloadProgress }}%</span>
        </div>
      </div>
      
      <!-- Pause / Restart buttons -->
      <div class="px-4 pb-3 flex gap-2">
        <button
          class="flex-1 h-7 flex items-center justify-center gap-1.5 rounded text-[9px] font-bold uppercase tracking-wider border transition-all hover:scale-[1.02] active:scale-95"
          :style="{ color: 'rgba(var(--theme-accent-rgb), 0.7)', borderColor: 'rgba(var(--theme-accent-rgb), 0.2)', background: 'rgba(var(--theme-accent-rgb), 0.05)' }"
          @click="store.isPreloading ? store.pausePreload() : store.preloadAssets('props')"
        >
          <FaIcon :icon="store.isPreloading ? 'pause' : 'play'" :size="10" />
          {{ store.isPreloading ? (store.t('menu.preloadPause') || 'Pause') : (store.t('menu.preloadContinue') || 'Continue') }}
        </button>
        <button
          class="flex-1 h-7 flex items-center justify-center gap-1.5 rounded text-[9px] font-bold uppercase tracking-wider border transition-all hover:scale-[1.02] active:scale-95"
          :style="{ color: 'rgba(var(--theme-accent-rgb), 0.7)', borderColor: 'rgba(var(--theme-accent-rgb), 0.2)', background: 'rgba(var(--theme-accent-rgb), 0.05)' }"
          @click="store.preloadAssets('props')"
        >
          <FaIcon icon="rotate-right" :size="10" />
          {{ store.t('menu.preloadRestart') || 'Restart' }}
        </button>
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

    <SectionCard
      v-for="item in visibleItems"
      :key="item.id"
      :title="getLabel(item)"
      :icon="item.icon"
      :default-open="true"
    >
      <template v-if="getProp(item.id) && getSetting(item.id)">
        <div class="grid grid-cols-2 gap-3 mt-1.5">
          <NumberStepper
            :label="store.t('props.drawable') || 'Model'"
            :model-value="getProp(item.id)!.drawable"
            :min="getSetting(item.id)?.drawable?.min ?? -1"
            :max="getSetting(item.id)?.drawable?.max ?? 0"
            :favorite-key="'prop_' + item.id"
            @update:model-value="updateDrawable(item.id, $event)"
          />
          <NumberStepper
            :label="store.t('props.texture') || 'Texture'"
            :model-value="getProp(item.id)!.texture"
            :min="getSetting(item.id)?.texture?.min ?? -1"
            :max="getSetting(item.id)?.texture?.max ?? 0"
            @update:model-value="updateTexture(item.id, $event)"
          />
        </div>
      </template>
    </SectionCard>
  </div>
</template>
