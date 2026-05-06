<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed } from 'vue'
import SectionCard from '@/components/shared/SectionCard.vue'
import NumberStepper from '@/components/shared/NumberStepper.vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const components = computed(() => store.appearance?.components ?? [])
const componentSettings = computed(() => store.settings?.components ?? [])
const componentConfig = computed(() => store.config.componentConfig)

// ── Section List ──
// component_id → configKey mapping (matches reference code order)
const componentItems: { id: number; configKey: string; localeKey: string; fallback: string; icon: string }[] = [
  { id: 11, configKey: 'jackets', localeKey: 'components.jackets', fallback: 'Jackets', icon: icons.clothing.jackets },
  { id: 8, configKey: 'shirts', localeKey: 'components.shirt', fallback: 'Shirts', icon: icons.clothing.shirts },
  { id: 3, configKey: 'upperBody', localeKey: 'components.upperBody', fallback: 'Hands', icon: icons.clothing.upperBody },
  { id: 4, configKey: 'lowerBody', localeKey: 'components.lowerBody', fallback: 'Legs', icon: icons.clothing.lowerBody },
  { id: 6, configKey: 'shoes', localeKey: 'components.shoes', fallback: 'Shoes', icon: icons.clothing.shoes },
  { id: 10, configKey: 'decals', localeKey: 'components.decals', fallback: 'Decals', icon: icons.clothing.decals },
  { id: 1, configKey: 'masks', localeKey: 'components.mask', fallback: 'Masks', icon: icons.clothing.masks },
  { id: 9, configKey: 'bodyArmor', localeKey: 'components.bodyArmor', fallback: 'Body Armor', icon: icons.clothing.bodyArmor },
  { id: 5, configKey: 'bags', localeKey: 'components.bags', fallback: 'Bags', icon: icons.clothing.bags },
  { id: 7, configKey: 'scarfAndChains', localeKey: 'components.scarfAndChains', fallback: 'Scarf / Chains', icon: icons.clothing.scarfAndChains },
]

// Filter items by componentConfig flags AND favorites if active
const visibleItems = computed(() => {
  const cfg = componentConfig.value
  let items = componentItems.filter((item) => (cfg as any)[item.configKey] !== false)

  // Apply Config.UI.Sections.clothing whitelist (and ordering) when defined
  const allowed = store.getVisibleSections('clothing')
  if (allowed) {
    const order = new Map(allowed.map((k, i) => [k, i]))
    items = items
      .filter(it => order.has(it.configKey))
      .sort((a, b) => (order.get(a.configKey)! - order.get(b.configKey)!))
  }

  if (store.isFilterFavoritesActive) {
    items = items.filter(item => {
      const favKey = `${store.appearance?.model}_clothing_${item.id}`
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

function getLabel(item: typeof componentItems[0]): string {
  return store.t(item.localeKey) || item.fallback
}

function updateDrawable(componentId: number, drawable: number) {
  store.changeComponent({ component_id: componentId, drawable, texture: 0 })
}

function updateTexture(componentId: number, texture: number) {
  const comp = components.value.find((c) => c.component_id === componentId)
  if (comp) {
    store.changeComponent({ component_id: componentId, drawable: comp.drawable, texture })
  }
}

function getComponent(id: number) {
  return components.value.find((c) => c.component_id === id)
}

function getSetting(id: number) {
  return componentSettings.value.find((s) => s.component_id === id)
}
</script>

<template>
  <div class="space-y-2">
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-[14px] font-bold text-theme-text-secondary uppercase tracking-widest font-display">
        {{ store.t('components.title') || 'Clothing' }}
      </h2>
      <div class="flex items-center gap-2">
        <button
          class="px-3 py-1.5 rounded border transition-all duration-200 text-[10px] font-bold uppercase tracking-wider group flex items-center"
          :class="store.isFilterFavoritesActive ? 'text-white' : 'text-theme-text-muted hover:text-theme-text-primary'"
          :style="{
            backgroundColor: store.isFilterFavoritesActive ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.05)',
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
          @click="store.isPreloading ? (store.stopPreload(), store.preloadProgress = 0) : store.preloadAssets('components')"
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
    <div v-if="store.preloadProgress > 0" class="mb-6 rounded-theme-card border overflow-hidden transition-all duration-300"
      :style="{ borderColor: 'rgba(var(--theme-accent-rgb), 0.15)' }"
    >
      <div class="absolute inset-0 -z-10" style="background: var(--theme-bg-panel); transform: translateZ(0);"></div>
      <div class="px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <!-- Premium Icon Badge -->
          <div class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0"
            :style="{ background: 'rgba(var(--theme-accent-rgb), 0.1)', border: '1px solid rgba(var(--theme-accent-rgb), 0.2)' }"
          >
            <FaIcon icon="cloud-arrow-down" :size="14" class="text-theme-accent animate-pulse" />
          </div>
          <div class="flex flex-col">
            <h2 class="text-[12px] font-bold text-theme-accent uppercase tracking-widest font-display">
              {{ store.preloadItem }} {{ store.t('menu.loading') || 'Loading' }}
            </h2>
            <span class="text-[9px] text-theme-text-muted uppercase font-bold tracking-tighter opacity-40">
              {{ store.t('menu.synchronizing') || 'Synchronizing Assets...' }}
            </span>
          </div>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-[13px] font-black text-theme-text-primary tabular-nums tracking-wider">{{ store.preloadProgress }}%</span>
        </div>
      </div>

      <!-- Pause / Restart buttons -->
      <div class="px-4 pb-3 flex gap-2">
        <button
          class="flex-1 h-7 flex items-center justify-center gap-1.5 rounded text-[9px] font-bold uppercase tracking-wider border transition-all hover:scale-[1.02] active:scale-95"
          :style="{ color: 'rgba(var(--theme-accent-rgb), 0.7)', borderColor: 'rgba(var(--theme-accent-rgb), 0.2)', background: 'rgba(var(--theme-accent-rgb), 0.05)' }"
          @click="store.pausePreload()"
        >
          <FaIcon icon="pause" :size="10" />
          {{ store.t('menu.preloadPause') || 'Pause' }}
        </button>
        <button
          class="flex-1 h-7 flex items-center justify-center gap-1.5 rounded text-[9px] font-bold uppercase tracking-wider border transition-all hover:scale-[1.02] active:scale-95"
          :style="{ color: 'rgba(var(--theme-accent-rgb), 0.7)', borderColor: 'rgba(var(--theme-accent-rgb), 0.2)', background: 'rgba(var(--theme-accent-rgb), 0.05)' }"
          @click="store.preloadAssets('components')"
        >
          <FaIcon icon="rotate-right" :size="10" />
          {{ store.t('menu.preloadRestart') || 'Restart' }}
        </button>
      </div>
      
      <!-- Integrated Progress Track -->
      <div class="w-full h-[4px] relative" :style="{ background: 'rgba(var(--theme-accent-rgb), 0.08)' }">
        <div 
          class="h-full transition-all duration-500 relative"
          :style="{ width: store.preloadProgress + '%', background: 'var(--theme-accent)', boxShadow: '0 0 10px rgba(var(--theme-accent-rgb), 0.6)' }"
        >
          <div class="absolute right-0 top-0 w-12 h-full bg-gradient-to-r from-transparent to-white/40"></div>
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
      <template v-if="getComponent(item.id) && getSetting(item.id)">
        <div class="grid grid-cols-2 gap-3 mt-1.5">
          <NumberStepper
            :label="store.t('components.drawable') || 'Model'"
            :model-value="getComponent(item.id)!.drawable"
            :min="getSetting(item.id)?.drawable?.min ?? 0"
            :max="getSetting(item.id)?.drawable?.max ?? 0"
            :favorite-key="'clothing_' + item.id"
            @update:model-value="updateDrawable(item.id, $event)"
          />
          <NumberStepper
            :label="store.t('components.texture') || 'Texture'"
            :model-value="getComponent(item.id)!.texture"
            :min="getSetting(item.id)?.texture?.min ?? 0"
            :max="getSetting(item.id)?.texture?.max ?? 0"
            @update:model-value="updateTexture(item.id, $event)"
          />
        </div>
      </template>
    </SectionCard>
  </div>
</template>
