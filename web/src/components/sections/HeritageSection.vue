<script setup lang="ts">
import { useAppearanceStore } from '@/stores/appearance'
import { computed, reactive, watch } from 'vue'
import SectionCard from '@/components/shared/SectionCard.vue'
import NumberStepper from '@/components/shared/NumberStepper.vue'
import RangeSlider from '@/components/shared/RangeSlider.vue'
import type { HeadBlend } from '@/types'
import FaIcon from '@/components/shared/FaIcon.vue'
import { icons } from '@/config/icons'

const store = useAppearanceStore()

const blend = computed(() => store.appearance?.headBlend)
const settings = computed(() => store.settings?.headBlend)

const local = reactive<HeadBlend>({
  shapeFirst: 0, shapeSecond: 0, shapeThird: 0,
  skinFirst: 0, skinSecond: 0, skinThird: 0,
  shapeMix: 0, skinMix: 0, thirdMix: 0,
})

watch(blend, (val) => {
  if (val) Object.assign(local, val)
}, { immediate: true, deep: true })

function apply() {
  store.changeHeadBlend({ ...local })
}

function getMax(key: string) {
  return settings.value?.[key]?.max ?? 45
}

function getMin(key: string) {
  return settings.value?.[key]?.min ?? 0
}

function getStep(key: string) {
  return settings.value?.[key]?.factor ?? 1
}
</script>

<template>
  <div class="space-y-2">
    <h2 class="text-[14px] font-bold text-white uppercase tracking-widest font-display">
      {{ store.t('headBlend.title') }}
    </h2>

    <!-- Face Shape -->
    <SectionCard :title="store.t('headBlend.shape.title')" :icon="icons.heritage.shape" :default-open="true">
      <div class="grid grid-cols-2 gap-3 mt-1.5 mb-2">
        <NumberStepper
          :label="store.t('headBlend.shape.firstOption')"
          v-model="local.shapeFirst"
          :min="getMin('shapeFirst')"
          :max="getMax('shapeFirst')"
          @update:model-value="apply()"
        />
        <NumberStepper
          :label="store.t('headBlend.shape.secondOption')"
          v-model="local.shapeSecond"
          :min="getMin('shapeSecond')"
          :max="getMax('shapeSecond')"
          @update:model-value="apply()"
        />
      </div>
      <RangeSlider
        :label="store.t('headBlend.shape.mix')"
        v-model="local.shapeMix"
        :min="0"
        :max="1"
        :step="0.1"
        @update:model-value="apply()"
      />
    </SectionCard>

    <!-- Skin Tone -->
    <SectionCard :title="store.t('headBlend.skin.title')" :icon="icons.heritage.skin" :default-open="true">
      <div class="grid grid-cols-2 gap-3 mt-1.5 mb-2">
        <NumberStepper
          :label="store.t('headBlend.skin.firstOption')"
          v-model="local.skinFirst"
          :min="getMin('skinFirst')"
          :max="getMax('skinFirst')"
          @update:model-value="apply()"
        />
        <NumberStepper
          :label="store.t('headBlend.skin.secondOption')"
          v-model="local.skinSecond"
          :min="getMin('skinSecond')"
          :max="getMax('skinSecond')"
          @update:model-value="apply()"
        />
      </div>
      <RangeSlider
        :label="store.t('headBlend.skin.mix')"
        v-model="local.skinMix"
        :min="0"
        :max="1"
        :step="0.1"
        @update:model-value="apply()"
      />
    </SectionCard>

    <!-- Race/Third Mix -->
    <SectionCard :title="store.t('headBlend.race.title')" :icon="icons.heritage.race" :default-open="true">
      <div class="grid grid-cols-2 gap-3 mt-1.5 mb-2">
        <NumberStepper
          :label="store.t('headBlend.race.shape')"
          v-model="local.shapeThird"
          :min="getMin('shapeThird')"
          :max="getMax('shapeThird')"
          @update:model-value="apply()"
        />
        <NumberStepper
          :label="store.t('headBlend.race.skin')"
          v-model="local.skinThird"
          :min="getMin('skinThird')"
          :max="getMax('skinThird')"
          @update:model-value="apply()"
        />
      </div>
      <RangeSlider
        :label="store.t('headBlend.race.mix')"
        v-model="local.thirdMix"
        :min="0"
        :max="1"
        :step="0.1"
        @update:model-value="apply()"
      />
    </SectionCard>
  </div>
</template>
