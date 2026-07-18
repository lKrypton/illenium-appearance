<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed, reactive, watch } from 'vue'
import SectionCard from '@/components/shared/SectionCard.vue'
import RangeSlider from '@/components/shared/RangeSlider.vue'
import type { FaceFeatures } from '@/types'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const features = computed(() => store.appearance?.faceFeatures)

const local = reactive<FaceFeatures>({
  noseWidth: 0, nosePeakHigh: 0, nosePeakSize: 0,
  noseBoneHigh: 0, nosePeakLowering: 0, noseBoneTwist: 0,
  eyeBrownHigh: 0, eyeBrownForward: 0,
  cheeksBoneHigh: 0, cheeksBoneWidth: 0, cheeksWidth: 0,
  eyesOpening: 0, lipsThickness: 0,
  jawBoneWidth: 0, jawBoneBackSize: 0,
  chinBoneLowering: 0, chinBoneLenght: 0, chinBoneSize: 0, chinHole: 0,
  neckThickness: 0,
})

watch(features, (val) => {
  if (val) Object.assign(local, val)
}, { immediate: true, deep: true })

function apply() {
  store.changeFaceFeatures({ ...local })
}

interface FeatureGroup {
  titleKey: string
  icon: string
  items: { key: keyof FaceFeatures; labelKey: string }[]
}

const groups: FeatureGroup[] = [
  {
    titleKey: 'faceFeatures.nose.title', icon: icons.face.nose,
    items: [
      { key: 'noseWidth', labelKey: 'faceFeatures.nose.width' },
      { key: 'nosePeakHigh', labelKey: 'faceFeatures.nose.height' },
      { key: 'nosePeakSize', labelKey: 'faceFeatures.nose.size' },
      { key: 'noseBoneHigh', labelKey: 'faceFeatures.nose.boneHeight' },
      { key: 'nosePeakLowering', labelKey: 'faceFeatures.nose.peakHeight' },
      { key: 'noseBoneTwist', labelKey: 'faceFeatures.nose.boneTwist' },
    ],
  },
  {
    titleKey: 'faceFeatures.eyebrows.title', icon: icons.face.eyebrows,
    items: [
      { key: 'eyeBrownHigh', labelKey: 'faceFeatures.eyebrows.height' },
      { key: 'eyeBrownForward', labelKey: 'faceFeatures.eyebrows.depth' },
    ],
  },
  {
    titleKey: 'faceFeatures.cheeks.title', icon: icons.face.cheeks,
    items: [
      { key: 'cheeksBoneHigh', labelKey: 'faceFeatures.cheeks.boneHeight' },
      { key: 'cheeksBoneWidth', labelKey: 'faceFeatures.cheeks.boneWidth' },
      { key: 'cheeksWidth', labelKey: 'faceFeatures.cheeks.width' },
    ],
  },
  {
    titleKey: 'faceFeatures.eyesAndMouth.title', icon: icons.face.eyesAndMouth,
    items: [
      { key: 'eyesOpening', labelKey: 'faceFeatures.eyesAndMouth.eyesOpening' },
      { key: 'lipsThickness', labelKey: 'faceFeatures.eyesAndMouth.lipsThickness' },
    ],
  },
  {
    titleKey: 'faceFeatures.jaw.title', icon: icons.face.jaw,
    items: [
      { key: 'jawBoneWidth', labelKey: 'faceFeatures.jaw.width' },
      { key: 'jawBoneBackSize', labelKey: 'faceFeatures.jaw.size' },
    ],
  },
  {
    titleKey: 'faceFeatures.chin.title', icon: icons.face.chin,
    items: [
      { key: 'chinBoneLowering', labelKey: 'faceFeatures.chin.lowering' },
      { key: 'chinBoneLenght', labelKey: 'faceFeatures.chin.length' },
      { key: 'chinBoneSize', labelKey: 'faceFeatures.chin.size' },
      { key: 'chinHole', labelKey: 'faceFeatures.chin.hole' },
    ],
  },
  {
    titleKey: 'faceFeatures.neck.title', icon: icons.face.neck,
    items: [
      { key: 'neckThickness', labelKey: 'faceFeatures.neck.thickness' },
    ],
  },
]
</script>

<template>
  <div class="space-y-2">
    <h2 class="text-[14px] font-bold text-white uppercase tracking-widest font-display">
      {{ store.t('faceFeatures.title') }}
    </h2>

    <SectionCard
      v-for="group in groups"
      :key="group.titleKey"
      :title="store.t(group.titleKey)"
      :icon="group.icon"
      :default-open="true"
    >
      <RangeSlider
        v-for="item in group.items"
        :key="item.key"
        :label="store.t(item.labelKey)"
        v-model="local[item.key]"
        :min="-1"
        :max="1"
        :step="0.1"
        @update:model-value="apply()"
      />
    </SectionCard>
  </div>
</template>
