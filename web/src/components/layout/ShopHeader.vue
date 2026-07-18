<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'

const store = useAppearanceStore()

const getShopTitle = (shopType?: string) => {
  if (!shopType) return store.t('menu.title')
  switch(shopType.toLowerCase()) {
    case 'ponsonbys': return 'Ponsonbys'
    case 'binco': return 'Binco'
    case 'suburban': return 'Suburban'
    case 'barber': return store.t('menu.barberShopTitle')
    case 'tattoo': return store.t('menu.tattooShopTitle')
    case 'wardrobe': return store.t('outfits.save.menuTitle')
    default: return store.t('menu.title')
  }
}

function getTitleStyle(shopType?: string) {
  if (['suburban', 'creator'].includes(shopType || '')) {
    return { color: '#ffffff', textShadow: '0 4px 10px rgba(0,0,0,0.3)', webkitTextFillColor: 'initial', background: 'none' }
  }
  if (shopType === 'barber') {
    return { color: 'var(--theme-accent)', textShadow: '0 3px 3px rgba(0,0,0,0.5), 0 -1px 2px rgba(0,0,0,0.8)', filter: 'drop-shadow(0 4px 4px rgba(0,0,0,0.2))', webkitTextFillColor: 'initial', background: 'none' }
  }
  if (shopType === 'binco') {
    return { color: '#ffffff', textShadow: '3px 3px 0px rgba(249, 115, 22, 0.9)', webkitTextFillColor: 'initial', background: 'none' }
  }
  if (shopType === 'ponsonbys') {
    return { background: 'linear-gradient(to bottom, #f8fafc 0%, #cbd5e1 50%, #64748b 100%)', webkitBackgroundClip: 'text', webkitTextFillColor: 'transparent', textShadow: 'none' }
  }
  return { background: 'linear-gradient(135deg, var(--theme-accent) 0%, var(--theme-text-secondary) 100%)', webkitBackgroundClip: 'text', webkitTextFillColor: 'transparent', textShadow: '0 4px 10px rgba(0,0,0,0.2)' }
}
</script>

<template>
  <div 
    class="px-6 py-5 border-b border-theme-border shrink-0 flex flex-col items-center justify-center relative"
    :style="{ background: 'linear-gradient(to bottom, rgba(var(--theme-accent-rgb), 0.1), rgba(var(--theme-accent-rgb), 0.03))' }"
  >
    <div class="flex flex-col items-center w-fit">
      <h1 
        class="text-4xl font-display font-bold tracking-wider text-center drop-shadow-2xl" 
        :class="{'uppercase': store.config?.shopType !== 'ponsonbys'}"
        :style="getTitleStyle(store.config?.shopType)"
      >
        {{ getShopTitle(store.config?.shopType) }}
      </h1>
    </div>
  </div>
</template>
