<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed, ref, watch } from 'vue'
import RangeSlider from '@/components/shared/RangeSlider.vue'
import type { TattooItem, TattooZone } from '@/types'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const tattooSettings = computed(() => store.settings?.tattoos)
const currentTattoos = computed(() => store.appearance?.tattoos ?? {} as Record<TattooZone, TattooItem[]>)
const activeZone = ref<TattooZone>('ZONE_TORSO')

// The tattoo currently selected (being previewed)
const selectedTattoo = ref<TattooItem | null>(null)
// Opacity for preview/selection
const selectedOpacity = ref(0.5)

const baseTattooCost = computed(() => store.config?.tattooCost ?? 0)
const chargePerTattoo = computed(() => store.config?.chargePerTattoo ?? false)

const zones: { zone: TattooZone; localeKey: string; icon: string }[] = [
  { zone: 'ZONE_TORSO',     localeKey: 'tattoos.items.ZONE_TORSO',     icon: 'person' },
  { zone: 'ZONE_HEAD',      localeKey: 'tattoos.items.ZONE_HEAD',      icon: 'face-meh' },
  { zone: 'ZONE_LEFT_ARM',  localeKey: 'tattoos.items.ZONE_LEFT_ARM',  icon: 'child-reaching' },
  { zone: 'ZONE_RIGHT_ARM', localeKey: 'tattoos.items.ZONE_RIGHT_ARM', icon: 'child-reaching' },
  { zone: 'ZONE_LEFT_LEG',  localeKey: 'tattoos.items.ZONE_LEFT_LEG',  icon: 'socks' },
  { zone: 'ZONE_RIGHT_LEG', localeKey: 'tattoos.items.ZONE_RIGHT_LEG', icon: 'socks' },
]

const availableTattoos = computed(() => tattooSettings.value?.items?.[activeZone.value] ?? [])

const appliedTattoos = computed(() => currentTattoos.value?.[activeZone.value] ?? [])

const appliedCount = computed(() => {
  let count = 0
  const tattoos = currentTattoos.value
  if (!tattoos) return 0
  for (const zone of Object.keys(tattoos) as TattooZone[]) {
    count += (tattoos[zone] ?? []).length
  }
  return count
})

function tattooKey(t: TattooItem) {
  return `${t.collection}::${t.hashMale}::${t.hashFemale}`
}

function isTattooApplied(tattoo: TattooItem): boolean {
  return appliedTattoos.value.some((t) => tattooKey(t) === tattooKey(tattoo))
}

function getAppliedInstance(tattoo: TattooItem): TattooItem | undefined {
  return appliedTattoos.value.find((t) => tattooKey(t) === tattooKey(tattoo))
}

function getCost(tattoo: TattooItem): number {
  if (!chargePerTattoo.value) return 0
  return tattoo.cost ?? baseTattooCost.value
}

function isSelected(tattoo: TattooItem): boolean {
  return selectedTattoo.value != null && tattooKey(selectedTattoo.value) === tattooKey(tattoo)
}

function selectAndPreview(tattoo: TattooItem) {
  selectedTattoo.value = tattoo
  const applied = getAppliedInstance(tattoo)
  if (applied?.opacity != null) {
    selectedOpacity.value = applied.opacity
  }
  store.previewTattoo(currentTattoos.value, { ...tattoo, opacity: selectedOpacity.value })
}

watch(selectedOpacity, (op) => {
  const sel = selectedTattoo.value
  if (!sel) return
  const applied = getAppliedInstance(sel)
  if (applied) {
    const updated = { ...currentTattoos.value } as Record<TattooZone, TattooItem[]>
    updated[activeZone.value] = (updated[activeZone.value] ?? []).map((t) =>
      tattooKey(t) === tattooKey(sel) ? { ...t, opacity: op } : t
    )
    store.updateTattoos(updated)
  } else {
    store.previewTattoo(currentTattoos.value, { ...sel, opacity: op })
  }
})

watch(activeZone, () => {
  selectedTattoo.value = null
  selectedOpacity.value = 1
})

async function buySelected() {
  const sel = selectedTattoo.value
  if (!sel || isTattooApplied(sel)) return
  const updated = { ...currentTattoos.value } as Record<TattooZone, TattooItem[]>
  if (!updated[activeZone.value]) updated[activeZone.value] = []
  const tattooWithOpacity = { ...sel, opacity: selectedOpacity.value }
  updated[activeZone.value] = [...updated[activeZone.value], tattooWithOpacity]
  await store.applyTattoo(tattooWithOpacity, updated)
}

function deleteSelected() {
  const sel = selectedTattoo.value
  if (!sel || !isTattooApplied(sel)) return
  removeTattoo(sel)
  selectedTattoo.value = null
}

function removeTattoo(tattoo: TattooItem) {
  const updated = { ...currentTattoos.value } as Record<TattooZone, TattooItem[]>
  updated[activeZone.value] = (updated[activeZone.value] ?? []).filter(
    (t) => tattooKey(t) !== tattooKey(tattoo)
  )
  store.deleteTattoo(updated)
}

function deleteAllTattoos() {
  const updated = { ...currentTattoos.value } as Record<TattooZone, TattooItem[]>
  for (const zone of Object.keys(updated) as TattooZone[]) {
    updated[zone] = []
  }
  store.deleteTattoo(updated)
  selectedTattoo.value = null
}

function fmtPrice(n: number) {
  return '$' + n.toLocaleString()
}
</script>

<template>
  <div class="space-y-4">

    <!-- Header -->
    <div class="flex items-center justify-between mb-2">
      <div class="space-y-1">
        <h2 class="text-[14px] font-bold text-theme-text-secondary uppercase tracking-widest font-display">
          {{ store.t('tattoos.title') }}
        </h2>
        <div class="h-0.5 w-8 rounded-full" style="background: var(--theme-accent); opacity: 0.5" />
      </div>
      <div class="flex flex-col items-end">
        <span class="text-[13px] font-black text-theme-accent tabular-nums">{{ appliedCount }}</span>
        <span class="text-[8px] font-bold text-theme-text-muted uppercase tracking-tighter">
          {{ store.t('tattoos.applied') }}
        </span>
      </div>
    </div>

    <!-- Zone Selector Grid -->
    <div class="grid grid-cols-3 gap-2">
      <button
        v-for="z in zones"
        :key="z.zone"
        class="group flex flex-col items-center justify-center gap-1.5 py-3 px-2 rounded-xl transition-all duration-200"
        :style="activeZone === z.zone
          ? 'background: rgba(255,255,255,0.06); box-shadow: inset 0 0 0 1px var(--theme-accent), inset 0 0 16px rgba(var(--theme-accent-rgb),0.25); color: var(--theme-accent)'
          : 'background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.45)'"
        @click="activeZone = z.zone"
      >
        <FaIcon :icon="z.icon" :size="15" />
        <span class="text-[9px] font-black uppercase tracking-widest text-center w-full truncate">
          {{ store.t(z.localeKey) }}
        </span>
      </button>
    </div>

    <!-- Selected Tattoo Detail Panel -->
    <div
      v-if="selectedTattoo"
      class="rounded-xl overflow-hidden"
      style="background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.09); transform: translateZ(0)"
    >
      <div class="p-4 space-y-3">
        <!-- Title row -->
        <div class="flex items-start justify-between gap-3">
          <div class="min-w-0 flex-1">
            <div class="flex items-center gap-2">
              <div class="w-1 h-4 rounded-full" style="background: var(--theme-accent)" />
              <h3 class="text-[13px] font-black text-theme-text-primary uppercase tracking-wider truncate">
                {{ selectedTattoo.label || selectedTattoo.name }}
              </h3>
            </div>
            <p class="text-[9px] font-bold text-theme-text-muted uppercase tracking-widest mt-0.5 pl-3">
              {{ selectedTattoo.collection.replace('mp_', '').replace(/_/g, ' ') }}
            </p>
          </div>
          <!-- Applied badge -->
          <div
            v-if="isTattooApplied(selectedTattoo)"
            class="shrink-0 px-2.5 py-1 rounded-lg text-[9px] font-black uppercase tracking-widest flex items-center gap-1.5"
            style="background: rgba(34,197,94,0.15); color: rgb(74,222,128)"
          >
            <FaIcon icon="check" :size="9" />
            {{ store.t('tattoos.applied') }}
          </div>
        </div>

        <!-- Opacity slider -->
        <div class="rounded-lg p-3" style="background: rgba(255,255,255,0.03)">
          <RangeSlider
            :label="store.t('tattoos.opacity')"
            v-model="selectedOpacity"
            :min="0.1"
            :max="1"
            :step="0.1"
          />
        </div>

        <!-- Action buttons -->
        <div class="flex gap-2">
          <button
            v-if="!isTattooApplied(selectedTattoo)"
            class="flex-1 h-10 flex items-center justify-center gap-2 rounded-xl text-[11px] font-black uppercase tracking-widest transition-all duration-200 text-black"
            style="background: var(--theme-accent)"
            @click="buySelected"
          >
            <FaIcon icon="pen-nib" :size="13" />
            {{ chargePerTattoo ? (store.t('tattoos.buy')) : (store.t('tattoos.apply')) }}
          </button>
          <button
            v-else
            class="flex-1 h-10 flex items-center justify-center gap-2 rounded-xl text-[11px] font-black uppercase tracking-widest transition-all duration-200"
            style="background: rgba(239,68,68,0.15); color: rgb(248,113,113); box-shadow: inset 0 0 0 1px rgba(239,68,68,0.25)"
            @click="deleteSelected"
          >
            <FaIcon icon="trash" :size="13" />
            {{ store.t('tattoos.delete') }}
          </button>
        </div>
      </div>
    </div>

    <!-- Delete All -->
    <div v-if="appliedCount > 0" class="flex justify-end">
      <button
        class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-[9px] font-black uppercase tracking-widest transition-all duration-200"
        style="background: rgba(239,68,68,0.1); color: rgb(248,113,113); box-shadow: inset 0 0 0 1px rgba(239,68,68,0.2)"
        @click="deleteAllTattoos"
      >
        <FaIcon icon="trash" :size="11" />
        {{ store.t('tattoos.deleteAll') }}
      </button>
    </div>

    <!-- Tattoo List -->
    <div>
      <div
        v-if="availableTattoos.length === 0"
        class="py-12 text-center text-[11px] font-bold uppercase tracking-widest text-theme-text-muted opacity-40"
      >
        {{ store.t('tattoos.empty') }}
      </div>

      <div v-else class="flex flex-col gap-1.5 pb-4">
        <button
          v-for="(tattoo, idx) in availableTattoos"
          :key="idx"
          class="flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-150 text-left"
          :style="isSelected(tattoo)
            ? 'background: rgba(255,255,255,0.06); box-shadow: inset 0 0 0 1px var(--theme-accent), inset 0 0 14px rgba(var(--theme-accent-rgb),0.15)'
            : isTattooApplied(tattoo)
              ? 'background: rgba(var(--theme-accent-rgb),0.08); box-shadow: inset 0 0 0 1px rgba(var(--theme-accent-rgb),0.2)'
              : 'background: rgba(255,255,255,0.04)'"
          @click="selectAndPreview(tattoo)"
        >
          <!-- Check / dot -->
          <div
            class="w-6 h-6 rounded-lg flex items-center justify-center shrink-0 transition-all duration-200"
            :style="isTattooApplied(tattoo)
              ? 'background: var(--theme-accent); color: #000'
              : 'background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.2)'"
          >
            <FaIcon v-if="isTattooApplied(tattoo)" icon="check" :size="9" />
            <div v-else class="w-1.5 h-1.5 rounded-full" style="background: currentColor" />
          </div>

          <!-- Info -->
          <div class="min-w-0 flex-1">
            <div
              class="text-[11px] font-bold truncate"
              :style="isSelected(tattoo) ? 'color: var(--theme-accent)' : isTattooApplied(tattoo) ? 'color: rgba(255,255,255,0.9)' : 'color: rgba(255,255,255,0.65)'"
            >
              {{ tattoo.label || tattoo.name }}
            </div>
            <div class="text-[8px] font-bold uppercase tracking-wider truncate" style="color: rgba(255,255,255,0.28)">
              {{ tattoo.collection.replace('mp_', '').replace(/_/g, ' ') }}
            </div>
          </div>

          <!-- Price (if any) -->
          <div
            v-if="!isTattooApplied(tattoo) && chargePerTattoo && tattoo.cost"
            class="text-[10px] font-black tabular-nums shrink-0"
            style="color: var(--theme-accent)"
          >
            {{ fmtPrice(tattoo.cost) }}
          </div>
        </button>
      </div>
    </div>

  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar       { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(var(--theme-accent-rgb), 0.2);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(var(--theme-accent-rgb), 0.45);
}
</style>
