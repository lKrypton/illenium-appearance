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
  fallback: string
  icon: string
  items: { key: keyof FaceFeatures; labelKey: string; fallback: string }[]
}

const groups: FeatureGroup[] = [
  {
    titleKey: 'faceFeatures.nose.title', fallback: 'Nose', icon: icons.face.nose,
    items: [
      { key: 'noseWidth', labelKey: 'faceFeatures.nose.width', fallback: 'Width' },
      { key: 'nosePeakHigh', labelKey: 'faceFeatures.nose.height', fallback: 'Height' },
      { key: 'nosePeakSize', labelKey: 'faceFeatures.nose.size', fallback: 'Size' },
      { key: 'noseBoneHigh', labelKey: 'faceFeatures.nose.boneHeight', fallback: 'Bone Height' },
      { key: 'nosePeakLowering', labelKey: 'faceFeatures.nose.peakHeight', fallback: 'Peak Height' },
      { key: 'noseBoneTwist', labelKey: 'faceFeatures.nose.boneTwist', fallback: 'Bone Twist' },
    ],
  },
  {
    titleKey: 'faceFeatures.eyebrows.title', fallback: 'Eyebrows', icon: icons.face.eyebrows,
    items: [
      { key: 'eyeBrownHigh', labelKey: 'faceFeatures.eyebrows.height', fallback: 'Height' },
      { key: 'eyeBrownForward', labelKey: 'faceFeatures.eyebrows.depth', fallback: 'Depth' },
    ],
  },
  {
    titleKey: 'faceFeatures.cheeks.title', fallback: 'Cheeks', icon: icons.face.cheeks,
    items: [
      { key: 'cheeksBoneHigh', labelKey: 'faceFeatures.cheeks.boneHeight', fallback: 'Bone Height' },
      { key: 'cheeksBoneWidth', labelKey: 'faceFeatures.cheeks.boneWidth', fallback: 'Bone Width' },
      { key: 'cheeksWidth', labelKey: 'faceFeatures.cheeks.width', fallback: 'Width' },
    ],
  },
  {
    titleKey: 'faceFeatures.eyesAndMouth.title', fallback: 'Eyes & Mouth', icon: icons.face.eyesAndMouth,
    items: [
      { key: 'eyesOpening', labelKey: 'faceFeatures.eyesAndMouth.eyesOpening', fallback: 'Eyes Opening' },
      { key: 'lipsThickness', labelKey: 'faceFeatures.eyesAndMouth.lipsThickness', fallback: 'Lips Thickness' },
    ],
  },
  {
    titleKey: 'faceFeatures.jaw.title', fallback: 'Jaw', icon: icons.face.jaw,
    items: [
      { key: 'jawBoneWidth', labelKey: 'faceFeatures.jaw.width', fallback: 'Width' },
      { key: 'jawBoneBackSize', labelKey: 'faceFeatures.jaw.size', fallback: 'Size' },
    ],
  },
  {
    titleKey: 'faceFeatures.chin.title', fallback: 'Chin', icon: icons.face.chin,
    items: [
      { key: 'chinBoneLowering', labelKey: 'faceFeatures.chin.lowering', fallback: 'Lowering' },
      { key: 'chinBoneLenght', labelKey: 'faceFeatures.chin.length', fallback: 'Length' },
      { key: 'chinBoneSize', labelKey: 'faceFeatures.chin.size', fallback: 'Size' },
      { key: 'chinHole', labelKey: 'faceFeatures.chin.hole', fallback: 'Hole Size' },
    ],
  },
  {
    titleKey: 'faceFeatures.neck.title', fallback: 'Neck', icon: icons.face.neck,
    items: [
      { key: 'neckThickness', labelKey: 'faceFeatures.neck.thickness', fallback: 'Thickness' },
    ],
  },
]
</script>

<template>
  <div class="space-y-2">
    <h2 class="text-[14px] font-bold text-white uppercase tracking-widest font-display">
      {{ store.t('faceFeatures.title') || 'Face Features' }}
    </h2>

    <SectionCard
      v-for="group in groups"
      :key="group.titleKey"
      :title="store.t(group.titleKey) || group.fallback"
      :icon="group.icon"
      :default-open="true"
    >
      <RangeSlider
        v-for="item in group.items"
        :key="item.key"
        :label="store.t(item.labelKey) || item.fallback"
        v-model="local[item.key]"
        :min="-1"
        :max="1"
        :step="0.1"
        @update:model-value="apply()"
      />
    </SectionCard>
  </div>
</template>
