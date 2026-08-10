import { ref, computed, watch } from 'vue'
import { useAppearanceStore } from '@/stores/appearance'

export function useClothingToggles() {
  const store = useAppearanceStore()

  // ── Sentinel Config ──
  const toggleConfig = computed(() => {
    const isFemale = store.appearance?.model?.toLowerCase().includes('_f_') ?? false
    const ct = store.config?.clothingToggles
    const src = isFemale ? ct?.female : ct?.male
    return {
      jacketSentinel:     src?.jacketSentinel     ?? 15,
      undershirtSentinel: src?.undershirtSentinel ?? 15,
      torsoSentinel:      src?.torsoSentinel      ?? 15,
      lowerSentinel:      src?.lowerSentinel      ?? 21,
      shoesSentinel:      src?.shoesSentinel      ?? 34,
      hatSentinel:        src?.hatSentinel        ?? -1,
      maskSentinel:       src?.maskSentinel       ?? 0,
      glassesSentinel:    src?.glassesSentinel,
    }
  })

  // ── Saved Drawables ──
  const savedJacketDrawable     = ref(-1)
  const savedUndershirtDrawable = ref(-1)
  const savedTorsoDrawable      = ref(-1)
  const savedLowerDrawable      = ref(-1)
  const savedShoesDrawable      = ref(-1)
  const savedHatDrawable        = ref(-1)
  const savedMaskDrawable       = ref(-1)
  const savedGlassesDrawable    = ref(-1)

  // Only true once the user removes it, so nothing is red on first open
  const hatWasRemoved  = ref(false)
  const maskWasRemoved = ref(false)

  // ── Live Drawables ──
  const jacketDrawable = computed(() =>
    store.appearance?.components.find(c => c.component_id === 11)?.drawable ?? toggleConfig.value.jacketSentinel)
  const lowerDrawable = computed(() =>
    store.appearance?.components.find(c => c.component_id === 4)?.drawable ?? toggleConfig.value.lowerSentinel)
  const hatDrawable = computed(() =>
    store.appearance?.props.find(p => p.prop_id === 0)?.drawable ?? toggleConfig.value.hatSentinel)
  const maskDrawable = computed(() =>
    store.appearance?.components.find(c => c.component_id === 1)?.drawable ?? toggleConfig.value.maskSentinel)

  watch(jacketDrawable, (v) => { if (v !== toggleConfig.value.jacketSentinel) savedJacketDrawable.value = v }, { immediate: true })
  watch(lowerDrawable,  (v) => { if (v !== toggleConfig.value.lowerSentinel)  savedLowerDrawable.value  = v }, { immediate: true })
  watch(hatDrawable,    (v) => { if (v !== toggleConfig.value.hatSentinel)    savedHatDrawable.value    = v }, { immediate: true })
  watch(maskDrawable,   (v) => { if (v !== toggleConfig.value.maskSentinel)   savedMaskDrawable.value   = v }, { immediate: true })

  // ── Computed States ──
  const isUpperWorn = computed(() => jacketDrawable.value !== toggleConfig.value.jacketSentinel)
  const isLowerWorn = computed(() => lowerDrawable.value  !== toggleConfig.value.lowerSentinel)
  const isHatWorn   = computed(() => hatDrawable.value    !== toggleConfig.value.hatSentinel)
  const isMaskWorn  = computed(() => maskDrawable.value   !== toggleConfig.value.maskSentinel)

  // ── Toggle Functions ──
  function toggleUpper() {
    const comp = store.appearance?.components.find(c => c.component_id === 11)
    if (!comp) return
    if (isUpperWorn.value) {
      savedJacketDrawable.value    = comp.drawable
      savedUndershirtDrawable.value = store.appearance?.components.find(c => c.component_id === 8)?.drawable ?? -1
      savedTorsoDrawable.value      = store.appearance?.components.find(c => c.component_id === 3)?.drawable ?? -1
      store.changeComponent({ component_id: 11, drawable: toggleConfig.value.jacketSentinel,     texture: 0 })
      store.changeComponent({ component_id: 8,  drawable: toggleConfig.value.undershirtSentinel, texture: 0 })
      store.changeComponent({ component_id: 3,  drawable: toggleConfig.value.torsoSentinel,      texture: 0 })
    } else {
      store.changeComponent({ component_id: 11, drawable: savedJacketDrawable.value    >= 0 ? savedJacketDrawable.value    : 0, texture: comp.texture })
      store.changeComponent({ component_id: 8,  drawable: savedUndershirtDrawable.value >= 0 ? savedUndershirtDrawable.value : 0, texture: 0 })
      store.changeComponent({ component_id: 3,  drawable: savedTorsoDrawable.value      >= 0 ? savedTorsoDrawable.value      : 0, texture: 0 })
    }
  }

  function toggleLower() {
    const comp = store.appearance?.components.find(c => c.component_id === 4)
    if (!comp) return
    if (isLowerWorn.value) {
      savedLowerDrawable.value = comp.drawable
      savedShoesDrawable.value = store.appearance?.components.find(c => c.component_id === 6)?.drawable ?? -1
      store.changeComponent({ component_id: 4, drawable: toggleConfig.value.lowerSentinel,  texture: 0 })
      store.changeComponent({ component_id: 6, drawable: toggleConfig.value.shoesSentinel, texture: 0 })
    } else {
      store.changeComponent({ component_id: 4, drawable: savedLowerDrawable.value >= 0 ? savedLowerDrawable.value : 0, texture: comp.texture })
      store.changeComponent({ component_id: 6, drawable: savedShoesDrawable.value >= 0 ? savedShoesDrawable.value  : 0, texture: 0 })
    }
  }

  function toggleHat() {
    if (!isHatWorn.value && !hatWasRemoved.value) return
    const hat = store.appearance?.props.find(p => p.prop_id === 0)
    if (!hat) return
    if (isHatWorn.value) {
      savedHatDrawable.value = hat.drawable
      store.changeProp({ prop_id: 0, drawable: toggleConfig.value.hatSentinel, texture: 0 })
      hatWasRemoved.value = true
    } else {
      const restoreTo = savedHatDrawable.value !== toggleConfig.value.hatSentinel ? savedHatDrawable.value : 0
      store.changeProp({ prop_id: 0, drawable: restoreTo, texture: hat.texture })
      hatWasRemoved.value = false
    }
  }

  function toggleMask() {
    if (!isMaskWorn.value && !maskWasRemoved.value) return
    const comp = store.appearance?.components.find(c => c.component_id === 1)
    if (!comp) return
    if (isMaskWorn.value) {
      savedMaskDrawable.value = comp.drawable
      store.changeComponent({ component_id: 1, drawable: toggleConfig.value.maskSentinel, texture: 0 })
      if (toggleConfig.value.glassesSentinel !== undefined) {
        const glasses = store.appearance?.props.find(p => p.prop_id === 1)
        savedGlassesDrawable.value = glasses?.drawable ?? -1
        store.changeProp({ prop_id: 1, drawable: toggleConfig.value.glassesSentinel, texture: 0 })
      }
      maskWasRemoved.value = true
    } else {
      const restoreTo = savedMaskDrawable.value !== toggleConfig.value.maskSentinel ? savedMaskDrawable.value : 1
      store.changeComponent({ component_id: 1, drawable: restoreTo, texture: comp.texture })
      if (toggleConfig.value.glassesSentinel !== undefined) {
        const glassesRestore = savedGlassesDrawable.value >= 0 ? savedGlassesDrawable.value : 0
        store.changeProp({ prop_id: 1, drawable: glassesRestore, texture: 0 })
      }
      maskWasRemoved.value = false
    }
  }

  function resetOnMenuOpen() {
    hatWasRemoved.value = false
    maskWasRemoved.value = false
  }

  return {
    toggleConfig,
    isUpperWorn, isLowerWorn, isHatWorn, isMaskWorn,
    hatWasRemoved, maskWasRemoved,
    toggleUpper, toggleLower, toggleHat, toggleMask,
    resetOnMenuOpen,
  }
}
