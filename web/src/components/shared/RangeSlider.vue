<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  label: string
  modelValue: number
  min: number
  max: number
  step?: number
}>()

const emit = defineEmits<{
  'update:modelValue': [value: number]
}>()

function onInput(e: Event) {
  const val = parseFloat((e.target as HTMLInputElement).value)
  emit('update:modelValue', val)
}

const percentage = computed(() => {
  const range = props.max - props.min
  if (range === 0) return 0
  return ((props.modelValue - props.min) / range) * 100
})
</script>

<template>
  <div class="flex flex-col gap-2">
    <div class="flex items-center justify-between px-0.5 mb-0.5">
      <span class="text-[11px] font-bold text-theme-text-muted uppercase tracking-wider">{{ label }}</span>
      <span class="text-[11px] font-bold text-theme-text-secondary tabular-nums">{{ modelValue }}</span>
    </div>
    <div class="range-slider-wrapper" :class="`theme-aware-slider`">
      <div class="range-slider-track">
        <div class="range-slider-fill" :style="{ width: percentage + '%' }" />
      </div>
      <div class="range-slider-thumb" :style="{ left: percentage + '%' }" />
      <input
        type="range"
        :min="min"
        :max="max"
        :step="step ?? 1"
        :value="modelValue"
        class="range-slider-input"
        @input="onInput"
      />
    </div>
  </div>
</template>

<style scoped>
.range-slider-wrapper {
  position: relative;
  height: 20px;
  display: flex;
  align-items: center;
  padding: 0 4px;
}
.range-slider-track {
  width: 100%;
  height: 6px;
  background: rgba(var(--theme-accent-rgb), 0.1);
  border: 1px solid rgba(var(--theme-accent-rgb), 0.1);
  border-radius: 999px;
  overflow: hidden;
}
.range-slider-fill {
  height: 100%;
  border-radius: 999px;
  transition: width 0.1s ease;
  background: var(--theme-accent);
  box-shadow: 0 0 10px rgba(var(--theme-accent-rgb), 0.4);
}
.range-slider-thumb {
  position: absolute;
  top: 50%;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #ffffff;
  border: 3px solid var(--theme-accent);
  transform: translate(-50%, -50%);
  transition: all 0.15s ease;
  pointer-events: none;
  box-shadow: 0 0 12px rgba(var(--theme-accent-rgb), 0.5);
  z-index: 2;
}

.range-slider-wrapper:hover .range-slider-thumb {
  transform: translate(-50%, -50%) scale(1.15);
  box-shadow: 0 0 18px rgba(var(--theme-accent-rgb), 0.7);
}

.range-slider-input {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: pointer;
  margin: 0;
  z-index: 3;
}
</style>
