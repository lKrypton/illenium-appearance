<script setup lang="ts">
import { ref, computed, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { useAppearanceStore } from '@/stores/appearance'
import { useNuiEvent, fetchNui } from '@/utils/nui'

// Layout Components
import GameBlurCanvas from '@/components/layout/GameBlurCanvas.vue'
import LeftSidebar from '@/components/layout/LeftSidebar.vue'
import RightSidebar from '@/components/layout/RightSidebar.vue'
import ShopHeader from '@/components/layout/ShopHeader.vue'
import LightControlPanel from '@/components/layout/LightControlPanel.vue'
import OutfitsPanel from '@/components/layout/OutfitsPanel.vue'
import ConfirmModal from '@/components/shared/ConfirmModal.vue'

// Section Components
import ModelSection from '@/components/sections/ModelSection.vue'
import HeritageSection from '@/components/sections/HeritageSection.vue'
import FaceSection from '@/components/sections/FaceSection.vue'
import AppearanceSection from '@/components/sections/AppearanceSection.vue'
import HairSection from '@/components/sections/HairSection.vue'
import ClothingSection from '@/components/sections/ClothingSection.vue'
import AccessoriesSection from '@/components/sections/AccessoriesSection.vue'
import TattooSection from '@/components/sections/TattooSection.vue'

// Composables
import { useClothingToggles } from '@/composables/useClothingToggles'
import { useOrbitCamera } from '@/composables/useOrbitCamera'

// Config
import { icons } from '@/config/icons'
import type { TabId } from '@/types'

// ── Store ──
const store = useAppearanceStore()

// ── Composables ──
const { resetOnMenuOpen } = useClothingToggles()
const { orbitActive, exitOrbitMode, resetOrbitOnly, handleOrbitMouseDown, handleOrbitWheel } = useOrbitCamera()

// ── UI State ──
const showSaveModal = ref(false)
const showExitModal = ref(false)
const rightSidebarRef = ref<InstanceType<typeof RightSidebar> | null>(null)

// ── NUI Event Listeners ──
let removeDisplay: (() => void) | null = null
let removeHide: (() => void) | null = null

onMounted(() => {
  removeDisplay = useNuiEvent('appearance_display', () => {
    store.show()
  })

  removeHide = useNuiEvent('appearance_hide', () => {
    // Reset JS orbit state so next shop session starts clean.
    // Don't call exitOrbitMode() here (sends NUI) — Lua already ran exitPlayerCustomization.
    resetOrbitOnly()
    store.hide()
  })
})

onUnmounted(() => {
  removeDisplay?.()
  removeHide?.()
})

// ── Modal Handlers ──
function handleConfirmSave() {
  showSaveModal.value = false
  store.save()
}

function handleConfirmExit() {
  showExitModal.value = false
  store.exit()
}

// ── Sections ──
const sectionComponents: Record<string, any> = {
  model: ModelSection,
  heritage: HeritageSection,
  face: FaceSection,
  appearance: AppearanceSection,
  hair: HairSection,
  clothing: ClothingSection,
  accessories: AccessoriesSection,
  tattoos: TattooSection,
}

const allTabs = [
  { id: 'model' as TabId, icon: icons.tabs.model, labelKey: 'ped.title', fallback: 'Karakter' },
  { id: 'heritage' as TabId, icon: icons.tabs.heritage, labelKey: 'headBlend.title', fallback: 'Kalıtım' },
  { id: 'face' as TabId, icon: icons.tabs.face, labelKey: 'faceFeatures.title', fallback: 'Yüz' },
  { id: 'appearance' as TabId, icon: icons.tabs.appearance, labelKey: 'headOverlays.title', fallback: 'Görünüm' },
  { id: 'hair' as TabId, icon: icons.tabs.hair, labelKey: 'headOverlays.hair.title', fallback: 'Saç' },
  { id: 'clothing' as TabId, icon: icons.tabs.clothing, labelKey: 'components.title', fallback: 'Kıyafet' },
  { id: 'accessories' as TabId, icon: icons.tabs.accessories, labelKey: 'props.title', fallback: 'Aksesuar' },
  { id: 'tattoos' as TabId, icon: icons.tabs.tattoos, labelKey: 'tattoos.title', fallback: 'Dövme' },
]

const tabs = computed(() =>
  allTabs.filter(tab => store.availableTabs.includes(tab.id))
)

function selectTab(id: TabId) {
  store.activeTab = id
  if (id === 'clothing' || id === 'accessories') {
    fetchNui('appearance_close_interaction')
  }
}

// ── Keyboard Shortcuts ──
function handleKeydown(e: KeyboardEvent) {
  if (!store.isVisible || !store.isReady) return

  const tag = (e.target as HTMLElement)?.tagName
  if (tag === 'INPUT' || tag === 'TEXTAREA') return

  const num = parseInt(e.key)
  if (num >= 1 && num <= 8) {
    const tab = tabs.value[num - 1]
    if (tab) {
      e.preventDefault()
      selectTab(tab.id)
    }
    return
  }

  if (e.key === 'Escape') {
    e.preventDefault()
    if (showSaveModal.value) {
      showSaveModal.value = false
    } else if (showExitModal.value) {
      showExitModal.value = false
    } else if (store.config.enableExit) {
      showExitModal.value = true
    }
    return
  }

  if (e.key.toLowerCase() === 'a') {
    e.preventDefault()
    rightSidebarRef.value?.rotateLeft()
    return
  }
  if (e.key.toLowerCase() === 'd') {
    e.preventDefault()
    rightSidebarRef.value?.rotateRight()
    return
  }

  if (e.key === 'Enter' && !showSaveModal.value && !showExitModal.value) {
    e.preventDefault()
    showSaveModal.value = true
    return
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})

// ── Visibility Watcher ──
watch(() => store.isVisible, (v) => {
  if (v) {
    resetOnMenuOpen()
  } else {
    if (store.lightConfig.active) {
      store.updateLightConfig({ active: false })
      fetchNui('appearance_toggle_light', { state: false })
    }
  }
})

</script>

<template>
  <div
    v-if="store.isVisible && store.isReady"
    class="fixed top-0 left-0 w-full h-full z-[99999] pointer-events-none overflow-hidden"
  >
    <!-- Orbit Camera Overlay -->
    <div
      class="absolute inset-0 pointer-events-auto"
      style="z-index: 0;"
      :style="orbitActive ? 'cursor: grab;' : 'cursor: default;'"
      @wheel.prevent="handleOrbitWheel"
      @mousedown="handleOrbitMouseDown"
    />
    
    <!-- REAL-TIME ANIMATED LAYOUT -->
    <div class="absolute inset-0 pointer-events-none p-4" style="z-index: 1;">
      
      <!-- MAIN PANEL GROUP: NAVIGATION + PANEL -->
      <div 
        class="absolute top-4 bottom-4 h-[calc(100%-2rem)] flex gap-2 items-stretch"
        style="left: 1rem; flex-direction: row;"
      >
        <!-- LEFT SIDEBAR -->
        <LeftSidebar 
          :tabs="tabs"
          @select-tab="selectTab"
          @save="showSaveModal = true"
          @exit="showExitModal = true"
        />

        <!-- CENTER PANEL -->
        <div 
          class="w-[420px] h-full flex flex-col pointer-events-auto rounded-theme-panel border border-theme-border shadow-2xl overflow-hidden shrink-0 relative"
        >
          <!-- Frosted Glass Blur Canvas — only shows blurred game frame inside this panel -->
          <GameBlurCanvas style="z-index: -20;" />
          <!-- Stable Background Layer -->
          <div 
            class="absolute inset-0 bg-theme-panel -z-10 pointer-events-none"
            style="will-change: transform; transform: translateZ(0);"
          ></div>
          <ShopHeader />

          <div class="flex-1 overflow-y-auto px-2 py-5 space-y-4 min-h-0 custom-scrollbar" style="scrollbar-gutter: stable both-edges;">
             <div v-if="store.isLoading" class="flex items-center justify-center h-32">
               <div class="w-7 h-7 rounded-full animate-spin" style="border: 2px solid var(--theme-accent-border); border-top-color: var(--theme-accent);" />
             </div>
             <Transition v-else name="section-fade" mode="out-in">
               <component :is="sectionComponents[store.activeTab]" :key="store.activeTab" />
             </Transition>
          </div>
        </div>
      </div>

      <!-- UTILITY GROUP: SIDEBAR + LIGHTS -->
      <div 
        class="absolute top-4 bottom-4 h-[calc(100%-2rem)] flex items-center"
        style="right: 1rem;"
      >
        <div class="relative h-fit flex items-end">
          <Transition name="panel-slide-left">
            <LightControlPanel v-if="store.isLightPanelOpen" />
          </Transition>
          <Transition name="panel-slide-left">
            <OutfitsPanel v-if="store.isOutfitsPanelOpen" />
          </Transition>
          <RightSidebar ref="rightSidebarRef" />
        </div>
      </div>
    </div>

    <!-- Modals -->
    <ConfirmModal :visible="showSaveModal" variant="save" @confirm="handleConfirmSave" @cancel="showSaveModal = false" />
    <ConfirmModal :visible="showExitModal" variant="exit" @confirm="handleConfirmExit" @cancel="showExitModal = false" />
  </div>
</template>

<style>
/* Custom Cubic Bezier for cinematic movement */
.cubic-bezier {
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}
</style>
