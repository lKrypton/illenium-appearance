<script setup lang="ts">
defineProps<{
  label: string
  colors: number[][] // [[R,G,B], ...]
  modelValue: number
}>()

const emit = defineEmits<{
  'update:modelValue': [value: number]
}>()
</script>

<template>
  <div class="flex flex-col gap-2">
    <span class="text-[11px] font-bold text-theme-text-muted uppercase tracking-wider px-0.5">{{ label }}</span>
    <div class="flex flex-wrap gap-2.5 max-h-[140px] overflow-y-auto pr-1 p-1">
      <button
        v-for="(color, idx) in colors"
        :key="idx"
        class="w-6 h-6 theme-aware-swatch transition-all duration-200 flex-shrink-0 relative overflow-hidden"
        :class="{ 'active-swatch': idx === modelValue }"
        @click="emit('update:modelValue', idx)"
      >
        <div 
          class="absolute inset-0 pointer-events-none -z-10" 
          :style="{ backgroundColor: `rgb(${color[0]}, ${color[1]}, ${color[2]})` }"
        ></div>
      </button>

    </div>
  </div>
</template>

<style scoped>
.theme-aware-swatch {
  border-radius: 999px; /* Make them circles for a more premium look */
  border: 2px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.theme-aware-swatch:hover {
  border-color: rgba(255, 255, 255, 0.5);
}

.active-swatch {
  border: 3px solid var(--theme-accent) !important; /* Thick and bright border as requested */
  transform: scale(1.15) !important;
  box-shadow: none !important; /* ONLY shadow/glow is removed */
  z-index: 10;
}
</style>
