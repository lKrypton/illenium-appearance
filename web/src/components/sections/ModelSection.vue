<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed, ref, watch, onMounted, onUnmounted } from 'vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

// ── Virtual scroll config ──
const ITEM_HEIGHT = 50   // px — row slot height including vertical gap
const ROW_HEIGHT  = 44   // px — actual card height
const BUFFER      = 6    // extra rows rendered above/below viewport

const searchOpen     = ref(false)
const search         = ref('')
const selectedCategory = ref<'freemode' | 'animals' | 'multiplayer' | 'npc'>('freemode')
const scrollTop      = ref(0)
const containerH     = ref(440)
const containerRef   = ref<HTMLElement | null>(null)

// ── Raw model list ──
const models = computed(() => {
  const raw = store.settings?.ped?.model?.items ?? []
  return raw.map((item: any) =>
    typeof item === 'string'
      ? { model: item }
      : { model: item.model ?? '' }
  )
})

const currentModel = computed(() => (store.appearance?.model ?? '').toLowerCase())

// ── Category helpers ──
const pinnedModels = ['mp_m_freemode_01', 'mp_f_freemode_01']

function getCategory(model: string): 'freemode' | 'animals' | 'multiplayer' | 'npc' {
  const id = model.toLowerCase()
  if (id === 'mp_m_freemode_01' || id === 'mp_f_freemode_01') return 'freemode'
  if (id.startsWith('a_c_')) return 'animals'
  if (id.startsWith('mp_'))  return 'multiplayer'
  return 'npc'
}

const categories = computed(() => [
  { value: 'freemode'    as const, label: 'Freemode', count: models.value.filter(m => getCategory(m.model) === 'freemode').length },
  { value: 'multiplayer' as const, label: 'MP',       count: models.value.filter(m => getCategory(m.model) === 'multiplayer').length },
  { value: 'npc'         as const, label: 'NPC',      count: models.value.filter(m => getCategory(m.model) === 'npc').length },
  { value: 'animals'     as const, label: 'Animals',  count: models.value.filter(m => getCategory(m.model) === 'animals').length },
])

// ── Filtered + sorted list (computed once, never re-sorted on scroll) ──
const filteredModels = computed(() => {
  const seen = new Set<string>()
  const deduped = models.value.filter(m => {
    if (!m.model || seen.has(m.model)) return false
    seen.add(m.model); return true
  })

  const pinned: typeof deduped = []
  const rest:   typeof deduped = []
  for (const item of deduped) {
    pinnedModels.includes(item.model.toLowerCase()) ? pinned.push(item) : rest.push(item)
  }
  rest.sort((a, b) => a.model.localeCompare(b.model))

  const needle = search.value.trim().toLowerCase()
  return [...pinned, ...rest].filter(item => {
    if (getCategory(item.model) !== selectedCategory.value) return false
    return !needle || item.model.toLowerCase().includes(needle)
  })
})

// ── Virtual window ──
const visibleRange = computed(() => {
  const start = Math.max(0, Math.floor(scrollTop.value / ITEM_HEIGHT) - BUFFER)
  const end   = Math.min(
    filteredModels.value.length,
    Math.ceil((scrollTop.value + containerH.value) / ITEM_HEIGHT) + BUFFER
  )
  return { start, end }
})

const virtualItems = computed(() =>
  filteredModels.value
    .slice(visibleRange.value.start, visibleRange.value.end)
    .map((item, i) => ({ ...item, _top: (visibleRange.value.start + i) * ITEM_HEIGHT }))
)

const totalHeight = computed(() => filteredModels.value.length * ITEM_HEIGHT)

// ── Scroll handler (no throttle needed — scrollTop update is cheap) ──
function onScroll(e: Event) {
  scrollTop.value = (e.target as HTMLElement).scrollTop
}

// ── Reset scroll on filter change ──
watch([search, selectedCategory], () => {
  scrollTop.value = 0
  if (containerRef.value) containerRef.value.scrollTop = 0
})

// ── Measure container ──
function measureContainer() {
  if (containerRef.value) containerH.value = containerRef.value.clientHeight
}
onMounted(() => { measureContainer(); window.addEventListener('resize', measureContainer) })
onUnmounted(() => { window.removeEventListener('resize', measureContainer) })

function selectModel(model: string) { store.changeModel(model) }

function getModelIcon(model: string) {
  if (model.toLowerCase().startsWith('a_c_')) return icons.model.animal
  if (model.includes('_f_')) return icons.model.female
  if (model.includes('_m_')) return icons.model.male
  return icons.model.default
}
</script>

<template>
  <div class="flex flex-col gap-3">

    <!-- Header -->
    <div class="flex items-center justify-between">
      <h2 class="text-[14px] font-bold text-theme-text-secondary uppercase tracking-widest font-display">
        {{ store.t('ped.title') }}
      </h2>
      <button
        class="h-7 px-2.5 flex items-center gap-1.5 rounded-lg text-[10px] font-bold uppercase tracking-wider transition-all duration-200"
        :class="searchOpen ? 'text-theme-accent' : 'text-theme-text-muted hover:text-theme-text-secondary'"
        :style="searchOpen ? 'background: rgba(var(--theme-accent-rgb),0.15)' : 'background: rgba(255,255,255,0.08)'"
        @click="searchOpen = !searchOpen; if (!searchOpen) search = ''"
      >
        <FaIcon icon="magnifying-glass" :size="11" />
        <span>Search</span>
      </button>
    </div>

    <!-- Search input -->
    <Transition name="search-slide">
      <div
        v-if="searchOpen"
        class="flex items-center gap-2 rounded-xl px-3 py-2"
        style="background: rgba(255,255,255,0.06);"
      >
        <FaIcon icon="magnifying-glass" :size="12" class="text-theme-text-muted shrink-0" />
        <input
          v-model="search"
          type="text"
          placeholder="Search model..."
          class="flex-1 bg-transparent text-[12px] text-theme-text-primary placeholder:text-theme-text-muted/60 outline-none"
        />
        <button
          v-if="search"
          class="text-theme-text-muted hover:text-theme-text-secondary transition-colors"
          @click="search = ''"
        >
          <FaIcon icon="xmark" :size="11" />
        </button>
      </div>
    </Transition>

    <!-- Category pills -->
    <div class="flex gap-1.5 flex-wrap">
      <button
        v-for="cat in categories"
        :key="cat.value"
        class="h-7 px-3 rounded-full text-[10px] font-bold uppercase tracking-wider transition-all duration-200"
        :class="selectedCategory === cat.value ? 'text-black font-black' : 'text-theme-text-muted hover:text-theme-text-secondary'"
        :style="selectedCategory === cat.value ? 'background: var(--theme-accent)' : 'background: rgba(255,255,255,0.06)'"
        @click="selectedCategory = cat.value"
      >
        {{ cat.label }}<span class="ml-1 opacity-60 font-medium">{{ cat.count }}</span>
      </button>
    </div>

    <!-- Count -->
    <div class="text-[10px] px-0.5" style="color: rgba(255,255,255,0.35)">
      {{ filteredModels.length }} models
    </div>

    <!-- Virtual scroll container — only ~15 DOM nodes regardless of list size -->
    <div
      ref="containerRef"
      class="overflow-y-auto"
      style="height: calc(100vh - 290px);"
      @scroll="onScroll"
    >
      <!-- Full-height spacer so scrollbar is accurate -->
      <div class="relative" :style="{ height: totalHeight + 'px' }">
        <button
          v-for="item in virtualItems"
          :key="item.model"
          class="absolute left-0 right-0 flex items-center gap-3 px-3 rounded-xl transition-colors duration-150 group"
          :style="[
            { top: item._top + 3 + 'px', height: ROW_HEIGHT + 'px' },
            currentModel === item.model.toLowerCase()
              ? 'background: rgba(255,255,255,0.05); box-shadow: inset 0 0 0 1px var(--theme-accent), inset 0 0 14px rgba(var(--theme-accent-rgb), 0.18)'
              : 'background: rgba(255,255,255,0.04)'
          ]"
          :class="currentModel === item.model.toLowerCase()
            ? 'text-theme-text-primary'
            : 'text-theme-text-muted hover:text-theme-text-secondary'"
          @click="selectModel(item.model)"
        >
          <!-- Icon -->
          <div
            class="w-7 h-7 rounded-lg flex items-center justify-center shrink-0 transition-colors duration-150"
            :class="currentModel === item.model.toLowerCase() ? 'text-theme-accent' : 'text-theme-text-muted/50 group-hover:text-theme-text-muted'"
            :style="currentModel === item.model.toLowerCase() ? 'background: rgba(var(--theme-accent-rgb), 0.2)' : 'background: rgba(255,255,255,0.05)'"
          >
            <FaIcon :icon="getModelIcon(item.model)" :size="14" />
          </div>

          <!-- Label only — centered vertically, no subtitle -->
          <span class="text-[11px] font-bold uppercase tracking-widest font-display truncate">
            {{ item.model.toUpperCase() }}
          </span>

          <!-- Active pip -->
          <div
            v-if="currentModel === item.model.toLowerCase()"
            class="ml-auto w-1 h-5 rounded-full bg-theme-accent shadow-[0_0_8px_rgba(var(--theme-accent-rgb),0.6)] shrink-0"
          />
        </button>
      </div>
    </div>

  </div>
</template>

<style scoped>
.search-slide-enter-active,
.search-slide-leave-active { transition: all 0.2s ease; }
.search-slide-enter-from,
.search-slide-leave-to    { opacity: 0; transform: translateY(-6px); }
</style>
