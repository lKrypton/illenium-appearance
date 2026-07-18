<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { ref, onMounted } from 'vue'
import FaIcon from '@/components/shared/FaIcon.vue'
import GameBlurCanvas from '@/components/layout/GameBlurCanvas.vue'
import { fetchNui } from '@/utils/nui'

const store = useAppearanceStore()

interface SavedOutfit {
  id: number
  name: string
  model?: string
}

const savedOutfits = ref<SavedOutfit[]>([])
const isLoading = ref(false)
const isSaving = ref(false)
const newOutfitName = ref('')
const showNameInput = ref(false)

async function loadOutfits() {
  isLoading.value = true
  try {
    const outfits = await fetchNui<SavedOutfit[]>('appearance_get_outfits')
    savedOutfits.value = Array.isArray(outfits) ? outfits : []
  } finally {
    isLoading.value = false
  }
}

async function wearOutfit(id: number) {
  await fetchNui('appearance_wear_outfit', { id })
}

async function deleteOutfit(id: number) {
  const res = await fetchNui<{ success: boolean; outfits?: SavedOutfit[] }>('appearance_delete_outfit', { id })
  if (res?.success && res.outfits) savedOutfits.value = res.outfits
  else loadOutfits()
}

function openSaveDialog() {
  newOutfitName.value = ''
  showNameInput.value = true
}

async function confirmSave() {
  const name = newOutfitName.value.trim()
  if (!name) return
  isSaving.value = true
  try {
    const res = await fetchNui<{ success: boolean; outfits?: SavedOutfit[]; reason?: string }>('appearance_save_outfit', { name })
    if (res?.success && res.outfits) {
      savedOutfits.value = res.outfits
      showNameInput.value = false
    } else if (res?.reason === 'no_money') {
      showNameInput.value = false // server already sent notification
    } else {
      // Reason may be 'exists' / 'invalid_name' — keep dialog open
    }
  } finally {
    isSaving.value = false
  }
}

onMounted(loadOutfits)
</script>

<template>
  <div 
    class="absolute bottom-0 w-80 rounded-theme-panel shadow-2xl p-6 flex flex-col gap-6 pointer-events-auto transition-all duration-700 overflow-hidden right-full mr-4"
    :style="{ 
      boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.5)',
      border: '1px solid rgba(var(--theme-accent-rgb), 0.2)',
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

    <!-- Header -->
    <div class="flex items-center gap-3 pb-4 panel-header-border">
      <div class="outfit-icon-box w-10 h-10 rounded-xl flex items-center justify-center text-theme-accent shadow-inner">
        <FaIcon icon="layer-group" :size="18" />
      </div>
      <div class="flex flex-col">
        <h3 class="text-sm font-display font-bold text-theme-text-primary tracking-widest uppercase">
          {{ store.t('menu.savedOutfits') }}
        </h3>
        <span class="text-[9px] text-theme-text-muted uppercase tracking-tighter opacity-70">{{ store.t('menu.wardrobeSubtitle') }}</span>
      </div>
    </div>

    <!-- Outfit List -->
    <div class="flex flex-col gap-2 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar">
      <!-- Empty State -->
      <div v-if="savedOutfits.length === 0" class="flex flex-col items-center justify-center py-10 gap-3">
        <div class="empty-icon-box w-14 h-14 rounded-2xl flex items-center justify-center opacity-30">
          <FaIcon icon="layer-group" :size="22" class="text-theme-accent" />
        </div>
        <div class="flex flex-col items-center gap-1">
          <span class="text-[11px] font-black uppercase tracking-widest opacity-40 text-theme-text-primary">
            {{ store.t('menu.wardrobeEmpty') }}
          </span>
          <span class="text-[9px] font-bold uppercase tracking-wider opacity-25 text-theme-text-muted">
            {{ store.t('menu.wardrobeEmptyHint') }}
          </span>
        </div>
      </div>

      <div 
        v-for="outfit in savedOutfits" 
        :key="outfit.id"
        class="outfit-card group relative flex items-center gap-3 p-3 rounded-theme-card transition-all duration-300"
      >
        <div class="outfit-item-icon w-8 h-8 rounded-lg flex items-center justify-center text-theme-accent shrink-0 shadow-inner">
           <FaIcon icon="shirt" :size="12" />
        </div>
        
        <div class="flex-1 min-w-0">
           <div class="text-[12px] font-black text-theme-text-primary truncate">{{ outfit.name }}</div>
           <div v-if="outfit.model" class="text-[9px] font-bold text-theme-text-muted uppercase tracking-wider opacity-60 truncate">{{ outfit.model }}</div>
        </div>

        <div class="flex items-center gap-1.5 opacity-0 group-hover:opacity-100 transition-all duration-300">
          <button 
            class="w-7 h-7 rounded bg-theme-accent text-white flex items-center justify-center hover:brightness-110 transition-all active:scale-90 shadow-lg"
            :title="store.t('outfits.change.title')"
            @click="wearOutfit(outfit.id)"
          >
            <FaIcon icon="play" :size="10" />
          </button>
          <button 
            class="w-7 h-7 rounded bg-red-500 text-white flex items-center justify-center hover:brightness-110 transition-all active:scale-90 shadow-lg"
            :title="store.t('outfits.delete.title')"
            @click="deleteOutfit(outfit.id)"
          >
            <FaIcon icon="trash" :size="10" />
          </button>
        </div>
      </div>
    </div>

    <!-- Save Name Input (toggled) -->
    <div v-if="showNameInput" class="flex flex-col gap-2 mt-2">
      <input
        v-model="newOutfitName"
        type="text"
        :placeholder="store.t('outfits.save.name.label')"
        class="w-full h-10 px-3 rounded-theme-card bg-black/40 text-theme-text-primary text-[12px] font-bold border focus:outline-none focus:border-theme-accent transition-all"
        :style="{ borderColor: 'rgba(var(--theme-accent-rgb), 0.25)' }"
        @keyup.enter="confirmSave"
        autofocus
      />
      <div class="flex gap-2">
        <button
          class="save-confirm-btn flex-1 h-9 rounded-theme-card text-[10px] font-black uppercase tracking-widest transition-all hover:scale-[1.02] active:scale-95 text-theme-accent border"
          :disabled="isSaving || !newOutfitName.trim()"
          @click="confirmSave"
        >
          {{ isSaving ? '...' : (store.t('modal.save.confirm')) }}
        </button>
        <button
          class="cancel-btn px-3 h-9 rounded-theme-card text-[10px] font-bold uppercase tracking-widest transition-all hover:scale-[1.02] active:scale-95 border"
          @click="showNameInput = false"
        >
          {{ store.t('modal.exit.cancel') }}
        </button>
      </div>
    </div>

    <!-- Save Current Button -->
    <button
      v-else
      class="save-outfit-btn mt-2 w-full h-11 flex items-center justify-center gap-2 rounded-theme-card bg-gradient-to-r from-theme-accent/20 to-theme-accent/5 text-theme-accent font-black text-[11px] uppercase tracking-widest transition-all duration-200 active:scale-[0.97] shadow-inner"
      :style="{ border: '1px solid rgba(var(--theme-accent-rgb), 0.25)' }"
      @click="openSaveDialog"
    >
       <FaIcon icon="plus" :size="12" />
       {{ store.t('outfits.save.menuTitle') }}
    </button>
  </div>
</template>

<style scoped>
/* GPU compositing fix — prevents icon backgrounds from disappearing/flashing in CEF */
.outfit-icon-box {
  background-color: rgba(var(--theme-accent-rgb), 0.1);
  border: 1px solid rgba(var(--theme-accent-rgb), 0.25);
  transform: translateZ(0);
  will-change: transform;
  backface-visibility: hidden;
}

.empty-icon-box {
  border: 1px solid rgba(var(--theme-accent-rgb), 0.3);
  background-color: rgba(var(--theme-accent-rgb), 0.05);
  transform: translateZ(0);
  will-change: transform;
  backface-visibility: hidden;
}

.outfit-item-icon {
  background-color: rgba(var(--theme-accent-rgb), 0.1);
  border: 1px solid rgba(var(--theme-accent-rgb), 0.2);
  transform: translateZ(0);
  will-change: transform;
  backface-visibility: hidden;
}

.panel-header-border {
  border-bottom: 1px solid rgba(var(--theme-accent-rgb), 0.12);
}

.save-confirm-btn {
  border-color: rgba(var(--theme-accent-rgb), 0.4);
  background-color: rgba(var(--theme-accent-rgb), 0.1);
  transform: translateZ(0);
  will-change: transform;
}

.cancel-btn {
  color: rgba(239, 68, 68, 0.8);
  border-color: rgba(239, 68, 68, 0.3);
  background-color: rgba(239, 68, 68, 0.08);
  transform: translateZ(0);
  will-change: transform;
}
.cancel-btn:hover {
  color: rgb(239, 68, 68);
  border-color: rgba(239, 68, 68, 0.5);
  background-color: rgba(239, 68, 68, 0.15);
}

.outfit-card {
  position: relative;
  background: linear-gradient(135deg, rgba(0,0,0,0.6) 0%, rgba(0,0,0,0.3) 100%);
  border: 1px solid rgba(var(--theme-accent-rgb), 0.12);
  transform: translateZ(0);
  will-change: transform;
  isolation: isolate;
  overflow: hidden;
}

.outfit-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, transparent 100%);
  pointer-events: none;
}

.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(var(--theme-accent-rgb), 0.1);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: rgba(var(--theme-accent-rgb), 0.3);
}

.save-outfit-btn:hover {
  background-image: linear-gradient(to right, rgba(var(--theme-accent-rgb), 0.35), rgba(var(--theme-accent-rgb), 0.15));
  border-color: rgba(var(--theme-accent-rgb), 0.5);
  box-shadow: 0 0 16px rgba(var(--theme-accent-rgb), 0.25), inset 0 0 8px rgba(var(--theme-accent-rgb), 0.1);
  transform: translateY(-1px) scale(1.01);
  color: white;
}
.save-outfit-btn:active {
  transform: scale(0.97);
  box-shadow: 0 0 6px rgba(var(--theme-accent-rgb), 0.2), inset 0 0 12px rgba(var(--theme-accent-rgb), 0.15);
}
</style>
