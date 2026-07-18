<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'
import type { TabId } from '@/types'
import GameBlurCanvas from '@/components/layout/GameBlurCanvas.vue'

const store = useAppearanceStore()

const tooltipClass = 'left-full ml-4'

const props = defineProps<{
  tabs: { id: TabId; icon: string; labelKey: string }[]
 }>()

const emit = defineEmits<{
  (e: 'selectTab', id: TabId): void
  (e: 'save'): void
  (e: 'exit'): void
}>()
</script>

<template>
  <div 
    class="w-20 h-full rounded-theme-panel shadow-2xl pointer-events-auto flex flex-col py-6 gap-3 items-center shrink-0 relative z-50 overflow-hidden"
    :style="{ 
      border: '1px solid rgba(var(--theme-accent-rgb), 0.15)',
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

    <div 
      class="w-12 h-12 flex items-center justify-center rounded-theme-card text-theme-accent mb-2 shadow-inner relative overflow-hidden"
      :style="{ border: '1px solid rgba(var(--theme-accent-rgb), 0.2)' }"
    >
      <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="transform: translateZ(0);"></div>
       <FaIcon icon="bag-shopping" :size="20" />
    </div>


    <div class="w-10 h-px mb-2 opacity-30" :style="{ background: 'var(--theme-accent)' }"></div>
    
    <!-- Vertical Tabs -->
    <button
      v-for="(tab, index) in tabs"
      :key="tab.id"
      class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all relative group shrink-0 border"
      :style="{ 
        backgroundColor: 'transparent',
        borderWidth: '1px',
        borderStyle: 'solid',
        borderColor: store.activeTab === tab.id ? 'var(--theme-accent)' : 'rgba(var(--theme-accent-rgb), 0.1)',
        boxShadow: store.activeTab === tab.id ? `inset 0 0 10px rgba(var(--theme-accent-rgb), 0.3)` : 'none'
      }"
      :class="store.activeTab === tab.id
        ? 'text-theme-accent scale-105 shadow-xl'
        : 'text-theme-text-muted hover:text-theme-text-primary hover:border-theme-accent/20 hover:scale-110'"
      @click="emit('selectTab', tab.id)"
    >
      <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="transform: translateZ(0);"></div>

      <FaIcon :icon="tab.icon" :size="20" class="transition-transform group-hover:scale-110" />
      <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-theme-accent-border rounded-lg text-[10px] font-bold text-theme-text-primary uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
        {{ store.t(tab.labelKey) }}
      </div>
    </button>

    <div class="mt-auto"></div>

    <!-- Separator -->
    <div class="w-10 h-px my-1" :style="{ background: 'rgba(var(--theme-accent-rgb), 0.2)' }"></div>

    <button
      v-if="store.config.enableSave"
      class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all relative group shrink-0 border border-emerald-500/20"
      :style="{ 
        backgroundColor: 'transparent',
        ...(!store.appearance?.model ? { opacity: 0.5, cursor: 'not-allowed' } : {})
      }"
      :class="'text-emerald-500 hover:text-emerald-400 hover:border-emerald-500/50 hover:scale-110'"
      @click="store.appearance?.model ? emit('save') : undefined"
    >
      <div class="absolute inset-0 bg-emerald-500/10 -z-10 pointer-events-none" style="transform: translateZ(0);"></div>

      <FaIcon icon="floppy-disk" :size="20" />
      <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-emerald-500/20 rounded-lg text-[10px] font-bold text-emerald-400 uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
        {{ store.t('modal.save.confirm') }}
      </div>
    </button>

    <button
      v-if="store.config.enableExit"
      class="w-12 h-12 flex items-center justify-center rounded-theme-card transition-all relative group shrink-0 border border-red-500/30 mb-2"
      :style="{ 
        backgroundColor: 'transparent'
      }"
      :class="'text-red-400 hover:text-red-300 hover:border-red-500/50 hover:scale-110'"
      @click="emit('exit')"
    >
      <div class="absolute inset-0 bg-red-500/10 -z-10 pointer-events-none" style="transform: translateZ(0);"></div>

      <FaIcon :icon="icons.actions.exit" :size="20" />
      <div :class="tooltipClass" class="absolute px-2.5 py-1.5 bg-theme-panel border border-red-500/20 rounded-lg text-[10px] font-bold text-red-400 uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap z-50 shadow-2xl">
        {{ store.t('modal.exit.confirm') }}
      </div>
    </button>
  </div>
</template>

<style scoped>
/* Tooltip fix: overflow:hidden clips absolute-positioned tooltips in CEF */
button {
  overflow: visible;
}
button > .\-z-10 {
  overflow: hidden;
  border-radius: inherit;
}
</style>
