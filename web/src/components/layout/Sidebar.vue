<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'
import type { TabId } from '@/types'
import { computed } from 'vue'

const store = useAppearanceStore()

const allTabs = [
  { id: 'model' as TabId, icon: icons.tabs.model, label: store.t('ped.title') || 'Karakter' },
  { id: 'heritage' as TabId, icon: icons.tabs.heritage, label: store.t('headBlend.title') || 'Kalıtım' },
  { id: 'face' as TabId, icon: icons.tabs.face, label: store.t('faceFeatures.title') || 'Yüz' },
  { id: 'appearance' as TabId, icon: icons.tabs.appearance, label: store.t('headOverlays.title') || 'Görünüm' },
  { id: 'hair' as TabId, icon: icons.tabs.hair, label: store.t('headOverlays.hair.title') || 'Saç' },
  { id: 'clothing' as TabId, icon: icons.tabs.clothing, label: store.t('components.title') || 'Kıyafetler' },
  { id: 'accessories' as TabId, icon: icons.tabs.accessories, label: store.t('props.title') || 'Aksesuarlar' },
  { id: 'tattoos' as TabId, icon: icons.tabs.tattoos, label: store.t('tattoos.title') || 'Dövmeler' },
]

/** Only show tabs that the current config allows */
const tabs = computed(() =>
  allTabs.filter(tab => store.availableTabs.includes(tab.id))
)

function selectTab(id: TabId) {
  store.activeTab = id

  const cameraMap: Record<TabId, string> = {
    model: 'default',
    heritage: 'head',
    face: 'head',
    appearance: 'head',
    hair: 'head',
    clothing: 'body',
    accessories: 'head',
    tattoos: 'default',
  }
  store.setCamera(cameraMap[id])
}
</script>

<template>
  <nav class="flex flex-col w-[64px] bg-dark-900 border-r border-white-5 shrink-0">
    <div class="flex flex-col items-center py-3 gap-0.5 flex-1 overflow-y-auto">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        class="relative w-[52px] h-[52px] flex flex-col items-center justify-center rounded-lg transition-colors duration-150 group"
        :class="store.activeTab === tab.id
          ? 'bg-accent-10 text-accent'
          : 'text-zinc-500 hover:text-zinc-300 hover:bg-dark-600-50'"
        @click="selectTab(tab.id)"
      >
        <!-- Active indicator bar -->
        <div
          v-if="store.activeTab === tab.id"
          class="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-6 bg-accent rounded-r-full shadow-[0_0_8px_rgba(220,38,38,0.6)]"
        />
        <FaIcon :icon="tab.icon" :size="20" />
        <span class="text-[8px] font-semibold uppercase tracking-wider mt-0.5 leading-none">{{ tab.label }}</span>
      </button>
    </div>
  </nav>
</template>
