<script setup lang="ts">
import { ref } from 'vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const props = defineProps<{
  title: string
  defaultOpen?: boolean
  icon?: string
}>()

const isOpen = ref(props.defaultOpen ?? true)
</script>

<template>
  <div 
    class="rounded-theme-card overflow-hidden border transition-all duration-300 relative z-0"
    :style="{ borderColor: 'rgba(255,255,255,0.08)' }"
  >
    <!-- Stable Card Background -->
    <div class="absolute inset-0 bg-theme-card -z-10 pointer-events-none" style="transform: translateZ(0);"></div>

    <button
      class="w-full flex items-center justify-between px-4 py-2.5 transition-colors group relative overflow-hidden"
      @click="isOpen = !isOpen"
    >
      <!-- Hover Background Layer -->
      <div class="absolute inset-0 bg-theme-card-hover opacity-0 group-hover:opacity-100 transition-opacity -z-10 pointer-events-none" style="transform: translateZ(0);"></div>
      
      <div class="flex items-center gap-3">
        <!-- Premium Icon Badge -->
        <div 
          v-if="icon" 
          class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 border transition-all duration-300 relative overflow-hidden"
          :style="{ 
            borderColor: 'rgba(var(--theme-accent-rgb, 255, 255, 255), 0.2)',
            boxShadow: isOpen 
              ? `inset 0 0 8px rgba(var(--theme-accent-rgb, 255, 255, 255), 0.2)`
              : 'none'
          }"
        >
          <div class="absolute inset-0 bg-theme-card-hover -z-10 pointer-events-none" style="transform: translateZ(0);"></div>
          <FaIcon :icon="icon" :size="14" class="text-theme-accent" />
        </div>
        <h2 class="text-[14px] font-bold text-theme-text-secondary uppercase tracking-widest font-display">
          {{ title }}
        </h2>
      </div>
      <FaIcon
        :icon="icons.shared.chevronDown"
        :size="14"
        class="text-theme-text-muted"
        :style="{ transition: 'transform 0.2s', transform: isOpen ? 'rotate(180deg)' : 'rotate(0deg)' }"
      />
    </button>

    <div 
      class="grid transition-all duration-300 ease-in-out"
      :style="{ 
        gridTemplateRows: isOpen ? '1fr' : '0fr',
        opacity: isOpen ? 1 : 0
      }"
    >
      <div class="overflow-hidden">
        <div class="px-4 pb-4 pt-2 space-y-3">
          <slot />
        </div>
      </div>
    </div>
  </div>
</template>
