<template>
  <FontAwesomeIcon :icon="['fas', icon]" :style="sizeStyle" />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

const props = withDefaults(defineProps<{
  icon: string
  size?: number
}>(), {
  size: 14,
})

const sizeStyle = computed(() => ({
  fontSize: props.size + 'px',
  width: props.size + 'px',
  height: props.size + 'px',
  display: 'inline-block' as const,
  verticalAlign: 'middle' as const,
}))
</script>
