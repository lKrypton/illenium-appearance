<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed, reactive, watch } from 'vue'
import SectionCard from '@/components/shared/SectionCard.vue'
import NumberStepper from '@/components/shared/NumberStepper.vue'
import RangeSlider from '@/components/shared/RangeSlider.vue'
import ColorPicker from '@/components/shared/ColorPicker.vue'
import type { HeadOverlays, HeadOverlayValue } from '@/types'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const overlays = computed(() => store.appearance?.headOverlays)
const overlaySettings = computed(() => store.settings?.headOverlays)

const local = reactive<HeadOverlays>({
  blemishes: { style: 0, opacity: 0 },
  beard: { style: 0, opacity: 0, color: 0, secondColor: 0 },
  eyebrows: { style: 0, opacity: 0, color: 0, secondColor: 0 },
  ageing: { style: 0, opacity: 0 },
  makeUp: { style: 0, opacity: 0, color: 0, secondColor: 0 },
  blush: { style: 0, opacity: 0, color: 0, secondColor: 0 },
  complexion: { style: 0, opacity: 0 },
  sunDamage: { style: 0, opacity: 0 },
  lipstick: { style: 0, opacity: 0, color: 0, secondColor: 0 },
  moleAndFreckles: { style: 0, opacity: 0 },
  chestHair: { style: 0, opacity: 0, color: 0, secondColor: 0 },
  bodyBlemishes: { style: 0, opacity: 0 },
})

watch(overlays, (val) => {
  if (val) {
    for (const key of Object.keys(val) as (keyof HeadOverlays)[]) {
      Object.assign(local[key], val[key])
    }
  }
}, { immediate: true, deep: true })

function apply() {
  store.changeHeadOverlays({ ...local })
}

type OverlayKey = keyof HeadOverlays

const overlayKeys: { key: OverlayKey; localeKey: string; hasColor: boolean; hasSecondColor: boolean; icon: string }[] = [
  { key: 'blemishes', localeKey: 'headOverlays.blemishes', hasColor: false, hasSecondColor: false, icon: icons.appearance.blemishes },
  { key: 'beard', localeKey: 'headOverlays.beard', hasColor: true, hasSecondColor: false, icon: icons.appearance.beard },
  { key: 'eyebrows', localeKey: 'headOverlays.eyebrows', hasColor: true, hasSecondColor: false, icon: icons.appearance.eyebrows },
  { key: 'ageing', localeKey: 'headOverlays.ageing', hasColor: false, hasSecondColor: false, icon: icons.appearance.ageing },
  { key: 'makeUp', localeKey: 'headOverlays.makeUp', hasColor: true, hasSecondColor: true, icon: icons.appearance.makeUp },
  { key: 'blush', localeKey: 'headOverlays.blush', hasColor: true, hasSecondColor: false, icon: icons.appearance.blush },
  { key: 'complexion', localeKey: 'headOverlays.complexion', hasColor: false, hasSecondColor: false, icon: icons.appearance.complexion },
  { key: 'sunDamage', localeKey: 'headOverlays.sunDamage', hasColor: false, hasSecondColor: false, icon: icons.appearance.sunDamage },
  { key: 'lipstick', localeKey: 'headOverlays.lipstick', hasColor: true, hasSecondColor: false, icon: icons.appearance.lipstick },
  { key: 'moleAndFreckles', localeKey: 'headOverlays.moleAndFreckles', hasColor: false, hasSecondColor: false, icon: icons.appearance.moleAndFreckles },
  { key: 'chestHair', localeKey: 'headOverlays.chestHair', hasColor: true, hasSecondColor: false, icon: icons.appearance.chestHair },
  { key: 'bodyBlemishes', localeKey: 'headOverlays.bodyBlemishes', hasColor: false, hasSecondColor: false, icon: icons.appearance.bodyBlemishes },
]

function getStyleMax(key: OverlayKey): number {
  return overlaySettings.value?.[key]?.style?.max ?? 30
}

function getColors(key: OverlayKey): number[][] {
  return overlaySettings.value?.[key]?.color?.items ?? []
}
</script>

<template>
  <div class="space-y-2">
    <h2 class="text-[14px] font-bold text-white uppercase tracking-widest font-display">
      {{ store.t('headOverlays.title') }}
    </h2>

    <SectionCard
      v-for="ov in overlayKeys"
      :key="ov.key"
      :title="store.t(ov.localeKey)"
      :icon="ov.icon"
      :default-open="true"
    >
      <NumberStepper
        :label="store.t('headOverlays.style')"
        v-model="local[ov.key].style"
        :min="0"
        :max="getStyleMax(ov.key)"
        @update:model-value="apply()"
      />
      <RangeSlider
        :label="store.t('headOverlays.opacity')"
        v-model="local[ov.key].opacity"
        :min="0"
        :max="1"
        :step="0.1"
        @update:model-value="apply()"
      />
      <template v-if="ov.hasColor && getColors(ov.key).length > 0">
        <ColorPicker
          :label="store.t('headOverlays.color')"
          :colors="getColors(ov.key)"
          v-model="(local[ov.key] as HeadOverlayValue & { color: number }).color"
          @update:model-value="apply()"
        />
        <ColorPicker
          v-if="ov.hasSecondColor"
          :label="store.t('headOverlays.secondColor')"
          :colors="getColors(ov.key)"
          v-model="(local[ov.key] as HeadOverlayValue & { secondColor: number }).secondColor"
          @update:model-value="apply()"
        />
      </template>
    </SectionCard>
  </div>
</template>
