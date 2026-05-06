<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { useAppearanceStore } from '@/stores/appearance'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const props = defineProps<{
  label: string
  modelValue: number
  min: number
  max: number
  favoriteKey?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: number]
}>()

const isEditing = ref(false)
const editValue = ref('')

// Local ref so rapid scroll events see the latest value immediately
const localValue = ref(props.modelValue)
watch(() => props.modelValue, (v) => {
  if (!isEditing.value) localValue.value = v
})

// ── Favorites Logic ──
const localFavorites = ref<number[]>([])

const favKey = computed(() => {
  if (!props.favoriteKey || !store.appearance?.model) return null
  return `${store.appearance.model}_${props.favoriteKey}`
})

watch(favKey, (key) => {
  if (!key) {
    localFavorites.value = []
    return
  }
  try {
    const data = JSON.parse(localStorage.getItem('illenium_favorites') || '{}')
    localFavorites.value = data[key] || []
  } catch {
    localFavorites.value = []
  }
}, { immediate: true })

const isFavorite = computed(() => localFavorites.value.includes(localValue.value))

function toggleFavorite() {
  if (!favKey.value) return
  const list = [...localFavorites.value]
  if (list.includes(localValue.value)) {
    localFavorites.value = list.filter(v => v !== localValue.value)
  } else {
    localFavorites.value = [...list, localValue.value]
  }
  
  try {
    const data = JSON.parse(localStorage.getItem('illenium_favorites') || '{}')
    data[favKey.value] = localFavorites.value
    localStorage.setItem('illenium_favorites', JSON.stringify(data))
  } catch {}
}

function decrement() {
  let newVal = localValue.value
  if (store.isFilterFavoritesActive && localFavorites.value.length > 0) {
    const sorted = [...localFavorites.value].sort((a, b) => a - b)
    const prev = sorted.reverse().find(v => v < localValue.value)
    newVal = prev !== undefined ? prev : sorted[0]
  } else {
    newVal = localValue.value > props.min ? localValue.value - 1 : props.max
  }
  localValue.value = newVal
  emit('update:modelValue', newVal)
}

function increment() {
  let newVal = localValue.value
  if (store.isFilterFavoritesActive && localFavorites.value.length > 0) {
    const sorted = [...localFavorites.value].sort((a, b) => a - b)
    const next = sorted.find(v => v > localValue.value)
    newVal = next !== undefined ? next : sorted[0]
  } else {
    newVal = localValue.value < props.max ? localValue.value + 1 : props.min
  }
  localValue.value = newVal
  emit('update:modelValue', newVal)
}

function startEdit() {
  editValue.value = String(localValue.value)
  isEditing.value = true
}

function commitEdit() {
  isEditing.value = false
  const parsed = parseInt(editValue.value, 10)
  if (isNaN(parsed)) return
  const clamped = Math.max(props.min, Math.min(props.max, parsed))
  localValue.value = clamped
  if (clamped !== props.modelValue) {
    emit('update:modelValue', clamped)
  }
}

function onEditKeydown(e: KeyboardEvent) {
  if (e.key === 'Enter') {
    commitEdit()
  } else if (e.key === 'Escape') {
    isEditing.value = false
  } else if (e.key === 'ArrowRight') {
    e.preventDefault()
    increment()
    editValue.value = String(localValue.value)
  } else if (e.key === 'ArrowLeft') {
    e.preventDefault()
    decrement()
    editValue.value = String(localValue.value)
  }
}

function onWheel(e: WheelEvent) {
  e.preventDefault()
  if (e.deltaY < 0) {
    increment()
  } else {
    decrement()
  }
}

// ── Hold to Repeat Logic ──
const repeatTimeout = ref<ReturnType<typeof setTimeout> | null>(null)
const repeatInterval = ref<ReturnType<typeof setInterval> | null>(null)

function startRepeat(fn: () => void) {
  stopRepeat()
  fn() // Initial click
  repeatTimeout.value = setTimeout(() => {
    repeatInterval.value = setInterval(fn, 50)
  }, 400)
}

function stopRepeat() {
  if (repeatTimeout.value) {
    clearTimeout(repeatTimeout.value)
    repeatTimeout.value = null
  }
  if (repeatInterval.value) {
    clearInterval(repeatInterval.value)
    repeatInterval.value = null
  }
}
</script>

<template>
  <div class="flex flex-col gap-1 w-full">
    <div class="flex items-center justify-between px-0.5">
      <div class="flex items-center gap-1.5">
        <span class="text-[11px] font-bold text-theme-text-muted uppercase tracking-wider">{{ label }}</span>
        <button 
          v-if="favoriteKey"
          @click.stop="toggleFavorite"
          class="text-[10px] transition-all hover:scale-110 active:scale-90"
          :class="isFavorite ? 'text-theme-accent drop-shadow-[0_0_5px_rgba(var(--theme-accent-rgb),0.5)]' : 'text-theme-text-muted hover:text-white'"
          title="Favorilere Ekle/Çıkar"
        >
          <FaIcon :icon="icons.shared.star" />
        </button>
      </div>
      <span class="text-[11px] font-bold tabular-nums text-theme-text-muted">
        <span class="text-theme-accent font-black">{{ localValue }}</span> <span class="opacity-50">/ {{ max }}</span>
      </span>
    </div>
    <div 
      class="flex items-center h-9 rounded-theme-card shrink-0 overflow-hidden theme-aware-stepper transition-all duration-300 relative z-0"
      tabindex="0"
      @keydown.left.stop.prevent="decrement"
      @keydown.right.stop.prevent="increment"
    >
      <!-- Main Stepper Background -->
      <div class="absolute inset-0 bg-stepper-main -z-10 pointer-events-none" style="transform: translateZ(0);"></div>

      <button
        class="w-9 h-full flex items-center justify-center text-theme-text-muted hover:text-theme-text-primary stepper-btn-left active:scale-90 transition-all duration-200 shrink-0 relative overflow-hidden"
        tabindex="-1"
        @mousedown="startRepeat(decrement)"
        @mouseup="stopRepeat"
        @mouseleave="stopRepeat"
      >
        <div class="absolute inset-0 bg-stepper-btn -z-10 pointer-events-none" style="transform: translateZ(0);"></div>
        <FaIcon :icon="icons.shared.chevronLeft" :size="12" />
      </button>
      
      <div
        v-if="!isEditing"
        class="flex-1 h-full flex items-center justify-center cursor-text select-none group/val relative bg-transparent hover:bg-theme-card/10 transition-colors"
        @click="startEdit"
        @wheel.prevent="onWheel"
      >
        <span class="text-[14px] font-black text-theme-text-primary tabular-nums tracking-wider">{{ localValue }}</span>
        <!-- Subtle indicator -->
        <div class="absolute bottom-1 w-4 h-0.5 rounded-full bg-theme-accent/20 group-hover/val:bg-theme-accent/50 transition-colors"></div>
      </div>
      <input
        v-else
        v-model="editValue"
        type="number"
        class="flex-1 h-full text-center text-[14px] font-black text-theme-accent outline-none tabular-nums [appearance:textfield] [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none bg-transparent"
        :min="min"
        :max="max"
        @blur="commitEdit"
        @keydown.stop="onEditKeydown"
        @wheel.prevent="onWheel"
        @vue:mounted="($event: any) => $event.el?.focus?.()"
      />
 
      <button
        class="w-9 h-full flex items-center justify-center text-theme-text-muted hover:text-theme-text-primary stepper-btn-right active:scale-90 transition-all duration-200 shrink-0 relative overflow-hidden"
        tabindex="-1"
        @mousedown="startRepeat(increment)"
        @mouseup="stopRepeat"
        @mouseleave="stopRepeat"
      >
        <div class="absolute inset-0 bg-stepper-btn -z-10 pointer-events-none" style="transform: translateZ(0);"></div>
        <FaIcon :icon="icons.shared.chevronRight" :size="12" />
      </button>
    </div>


  </div>
</template>

<style scoped>
.theme-aware-stepper {
  border: 1px solid rgba(var(--theme-accent-rgb), 0.15);
}

.bg-stepper-main {
  background: rgba(var(--theme-accent-rgb), 0.05);
}

.theme-aware-stepper:focus-within {
  border-color: rgba(var(--theme-accent-rgb), 0.5);
  box-shadow: 0 0 15px rgba(var(--theme-accent-rgb), 0.1);
}

.theme-aware-stepper:focus-within .bg-stepper-main {
  background: rgba(var(--theme-accent-rgb), 0.1);
}

.bg-stepper-btn {
  background: rgba(var(--theme-accent-rgb), 0.08);
}

.stepper-btn-left { border-right: 1px solid rgba(var(--theme-accent-rgb), 0.1); }
.stepper-btn-right { border-left: 1px solid rgba(var(--theme-accent-rgb), 0.1); }

.stepper-btn-left:hover .bg-stepper-btn, 
.stepper-btn-right:hover .bg-stepper-btn {
  background: var(--theme-accent);
}

input {
  background: transparent !important;
}

/* Chrome/CEF Autofill fix */
input:-webkit-autofill,
input:-webkit-autofill:hover, 
input:-webkit-autofill:focus, 
input:-webkit-autofill:active  {
  -webkit-box-shadow: 0 0 0 30px transparent inset !important;
  transition: background-color 5000s ease-in-out 0s;
  -webkit-text-fill-color: var(--theme-accent) !important;
}
</style>
