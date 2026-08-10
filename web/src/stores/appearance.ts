import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { fetchNui } from '@/utils/nui'
import type {
  AppearanceData,
  AppearanceSettings,
  SessionConfig,
  LocaleData,
  TabId,
  HeadBlend,
  FaceFeatures,
  HeadOverlays,
  HairValue,
  ComponentValue,
  PropValue,
  TattooItem,
  TattooZone,
} from '@/types'

export const useAppearanceStore = defineStore('appearance', () => {
  // ── State ──
  const isVisible = ref(false)
  const isLoading = ref(true)
  const isReady = ref(false) // true only after first init completes (prevents flicker)
  const isOutfitsPanelOpen = ref(false)
  const isLightPanelOpen = ref(false)
  const activeTab = ref<TabId>('model')
  const activeCamera = ref<string>('default')
  const activeRotation = ref<string>('default') // tracks current rotation: 'left' | 'right' | 'default'
  const isPreloading = ref(false)
  const preloadProgress = ref(0)
  const preloadItem = ref('')
  const cancelPreload = ref(false)
  const isFilterFavoritesActive = ref(false)

  const preloadState = ref({
    type: null as 'components' | 'props' | 'hair' | null,
    lastItemIndex: 0,
    lastDrawable: -2, // -2 means not started
    currentStep: 0,
    totalSteps: 0
  })

  const locales = ref<LocaleData>({})
  const settings = ref<AppearanceSettings | null>(null)
  const config = ref<SessionConfig>({
    ped: true, headBlend: true, faceFeatures: true, headOverlays: true,
    components: true, props: true, tattoos: true, enableExit: true, enableSave: true,
    hasTracker: false, automaticFade: false,
    componentConfig: { masks: true, upperBody: true, lowerBody: true, bags: true, shoes: true, scarfAndChains: true, shirts: true, bodyArmor: true, decals: true, jackets: true },
    propConfig: { hats: true, glasses: true, ear: true, watches: true, bracelets: true },
  })
  const appearance = ref<AppearanceData | null>(null)
  const originalAppearance = ref<AppearanceData | null>(null)
  const lightConfig = ref({
    r: 255,
    g: 255,
    b: 255,
    intensity: 10.0,
    distance: 2.5,
    angle: 0.0,
    height: 1.0,
    active: false
  })


  // ── Computed ──
  const isPaused = computed(() => !isPreloading.value && preloadProgress.value > 0)

  const hasChanges = computed(() => {
    if (!appearance.value || !originalAppearance.value) return false
    return JSON.stringify(appearance.value) !== JSON.stringify(originalAppearance.value)
  })

  /** Which tabs to show based on the Lua config flags */
  const availableTabs = computed<TabId[]>(() => {
    const c = config.value
    const tabs: TabId[] = []
    if (c.ped) tabs.push('model')
    if (c.headBlend) tabs.push('heritage')
    if (c.faceFeatures) tabs.push('face')
    if (c.headOverlays) tabs.push('appearance', 'hair')
    if (c.components) tabs.push('clothing')
    if (c.props) tabs.push('accessories')
    if (c.tattoos) tabs.push('tattoos')

    // Intersect with Config.UI.Tabs[shopType] when defined, preserving config order.
    const shop = c.shopType || 'creator'
    const allowed = c.uiConfig?.tabs?.[shop]
    if (allowed && allowed.length) {
      const enabled = new Set(tabs)
      return allowed.filter(t => enabled.has(t))
    }
    return tabs
  })

  /**
   * Returns the visible section keys for a given tab from Config.UI.Sections.
   * If config has no entry for that tab, returns null → caller shows everything.
   * Caller is responsible for matching keys against its internal section list.
   */
  function getVisibleSections(tabId: string): string[] | null {
    const list = config.value.uiConfig?.sections?.[tabId]
    return Array.isArray(list) && list.length ? list : null
  }

  // ── Locale Helper ──
  function t(path: string): string {
    const keys = path.split('.')
    // Try with UI prefix first (which is how the game sends it)
    let val: any = locales.value?.UI
    for (const key of keys) {
      val = val?.[key]
    }
    if (typeof val === 'string') return val
    
    // Fallback to raw path
    val = locales.value
    for (const key of keys) {
      val = val?.[key]
    }
    return typeof val === 'string' ? val : ''
  }

  // ── Init ──
  async function init() {
    isLoading.value = true
    try {
      const [loc, settingsRes, dataRes] = await Promise.all([
        fetchNui<LocaleData>('appearance_get_locales'),
        fetchNui<{ appearanceSettings: AppearanceSettings }>('appearance_get_settings'),
        fetchNui<{ config: SessionConfig; appearanceData: AppearanceData }>('appearance_get_data'),
      ])

      locales.value = loc ?? {}
      settings.value = settingsRes?.appearanceSettings ?? null
      config.value = dataRes?.config ?? config.value
      appearance.value = dataRes?.appearanceData ?? null
      originalAppearance.value = JSON.parse(JSON.stringify(dataRes?.appearanceData ?? null))

      // Apply theme from config
      applyTheme(config.value)

      // Auto-select first available tab
      if (availableTabs.value.length > 0 && !availableTabs.value.includes(activeTab.value)) {
        activeTab.value = availableTabs.value[0]
      }
    } catch (e) {
      console.error('[appearance] init error', e)
    } finally {
      isLoading.value = false
      isReady.value = true
    }
  }

  // ── Show / Hide ──
  function show() {
    isReady.value = false
    isVisible.value = true
    activeCamera.value = 'default'
    activeRotation.value = 'default'
    init()
  }

  function hide() {
    isVisible.value = false
    isReady.value = false
    isOutfitsPanelOpen.value = false
    isLightPanelOpen.value = false
    appearance.value = null
    settings.value = null
    originalAppearance.value = null
  }

  // ── Theme ──
  // Hex (#rrggbb) → "r, g, b" comma list (used inline for rgba(var(--theme-accent-rgb), …))
  function hexToRgbList(hex: string): string | null {
    const m = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex.trim())
    if (!m) return null
    return `${parseInt(m[1], 16)}, ${parseInt(m[2], 16)}, ${parseInt(m[3], 16)}`
  }

  // Build "rgba(r, g, b, a)" from a hex base + opacity
  function panelBgFromHex(hex: string, opacity: number): string | null {
    const rgb = hexToRgbList(hex)
    if (!rgb) return null
    return `rgba(${rgb}, ${Math.max(0, Math.min(1, opacity))})`
  }

  function applyTheme(cfg: SessionConfig) {
    const root = document.documentElement

    // Remove existing theme classes (kept for legacy CSS overrides like .theme-tattoo .range-slider-track)
    const knownThemes = ['theme-ponsonbys', 'theme-binco', 'theme-suburban', 'theme-barber', 'theme-tattoo', 'theme-creator', 'theme-wardrobe']
    root.classList.remove(...knownThemes)
    document.body.classList.remove(...knownThemes)

    const shopType = cfg.shopType || 'creator'
    const shopThemeClass = `theme-${shopType}`
    root.classList.add(shopThemeClass)
    document.body.classList.add(shopThemeClass)

    // Reset any previously inline-set vars so switching shops doesn't carry over.
    const dynamicVars = [
      '--theme-accent', '--theme-accent-rgb', '--theme-accent-border', '--theme-accent-bg',
      '--theme-bg-panel', '--theme-bg-base',
      '--theme-text-primary', '--theme-text-secondary', '--theme-text-muted',
      '--theme-font-sans', '--theme-font-display',
      '--theme-border-radius-panel', '--theme-border-radius-card',
      '--theme-panel-opacity',
    ]
    for (const v of dynamicVars) root.style.removeProperty(v)

    // Resolve theme entry from Config.UI.Themes (sent via uiConfig.themes)
    const themeEntry = cfg.uiConfig?.themes?.[shopType] || cfg.uiConfig?.themes?.creator || {}

    // setProperty with 'important' priority so we override any !important rules in themes.css
    const set = (name: string, value: string | undefined) => {
      if (value !== undefined && value !== '') root.style.setProperty(name, value, 'important')
    }

    if (themeEntry.accent) set('--theme-accent', themeEntry.accent)
    if (themeEntry.accentRgb) {
      set('--theme-accent-rgb', themeEntry.accentRgb)
      set('--theme-accent-border', `rgba(${themeEntry.accentRgb}, 0.4)`)
      set('--theme-accent-bg', `rgba(${themeEntry.accentRgb}, 0.12)`)
    } else if (themeEntry.accent) {
      const rgb = hexToRgbList(themeEntry.accent)
      if (rgb) {
        set('--theme-accent-rgb', rgb)
        set('--theme-accent-border', `rgba(${rgb}, 0.4)`)
        set('--theme-accent-bg', `rgba(${rgb}, 0.12)`)
      }
    }

    if (themeEntry.fontSans) set('--theme-font-sans', `'${themeEntry.fontSans}', sans-serif`)
    if (themeEntry.fontDisplay) set('--theme-font-display', `'${themeEntry.fontDisplay}', sans-serif`)

    if (themeEntry.roundedPanel) set('--theme-border-radius-panel', themeEntry.roundedPanel)
    if (themeEntry.roundedCard) set('--theme-border-radius-card', themeEntry.roundedCard)

    if (themeEntry.textPrimary) set('--theme-text-primary', themeEntry.textPrimary)
    if (themeEntry.textSecondary) set('--theme-text-secondary', themeEntry.textSecondary)
    if (themeEntry.textMuted) set('--theme-text-muted', themeEntry.textMuted)

    // Panel background (hex base + opacity → rgba)
    const baseHex = themeEntry.panelBaseHex || '#080808'
    const opacity = typeof themeEntry.panelOpacity === 'number' ? themeEntry.panelOpacity : 0.75
    const panelBg = panelBgFromHex(baseHex, opacity)
    if (panelBg) set('--theme-bg-panel', panelBg)
    set('--theme-panel-opacity', String(opacity))

    // panelBlur is intentionally not applied via CSS backdrop-filter here.
    // CEF does not support backdrop-filter. Blur is rendered by GameBlurCanvas (WebGL).

    // Legacy override path (cfg.theme.accentColor) still respected for back-compat
    const legacyTheme = cfg.theme
    if (legacyTheme?.accentColor) set('--theme-accent', legacyTheme.accentColor)
  }

  // ── Camera ──
  let cameraLocked = false

  function setCamera(cam: string) {
    if (cameraLocked) return
    cameraLocked = true
    window.setTimeout(() => { cameraLocked = false }, 400)

    // Toggle: if already active, go back to default
    if (activeCamera.value === cam) {
      activeCamera.value = 'default'
      fetchNui('appearance_set_camera', 'default')
    } else {
      activeCamera.value = cam
      fetchNui('appearance_set_camera', cam)
    }
  }

  function turnAround() {
    if (activeRotation.value === 'turn') {
      // Reset: re-set current camera to restore default position
      fetchNui('appearance_turn_around')
      activeRotation.value = 'default'
    } else {
      fetchNui('appearance_turn_around')
      activeRotation.value = 'turn'
    }
  }

  function rotateLeft() {
    if (activeRotation.value === 'left') {
      // Reset to default: re-set current camera position
      fetchNui('appearance_set_camera', activeCamera.value)
      activeRotation.value = 'default'
    } else {
      // If currently rotated right, reset first
      if (activeRotation.value === 'right') {
        fetchNui('appearance_set_camera', activeCamera.value)
      }
      fetchNui('appearance_rotate_camera', 'left')
      activeRotation.value = 'left'
    }
  }

  function rotateRight() {
    if (activeRotation.value === 'right') {
      // Reset to default: re-set current camera position
      fetchNui('appearance_set_camera', activeCamera.value)
      activeRotation.value = 'default'
    } else {
      // If currently rotated left, reset first
      if (activeRotation.value === 'left') {
        fetchNui('appearance_set_camera', activeCamera.value)
      }
      fetchNui('appearance_rotate_camera', 'right')
      activeRotation.value = 'right'
    }
  }

  // ── Model ──
  async function changeModel(model: string) {
    // We use a local loading state instead of the global one to prevent UI unmounting
    try {
      const res = await fetchNui<{
        appearanceSettings: AppearanceSettings
        appearanceData: AppearanceData
      }>('appearance_change_model', model)

      if (res) {
        settings.value = res.appearanceSettings
        appearance.value = res.appearanceData
      }
    } finally {
      // Done
    }
  }

  // ── Head Blend ──
  function changeHeadBlend(headBlend: HeadBlend) {
    if (!appearance.value) return
    appearance.value.headBlend = headBlend
    fetchNui('appearance_change_head_blend', headBlend)
  }

  // ── Face Features ──
  function changeFaceFeatures(faceFeatures: FaceFeatures) {
    if (!appearance.value) return
    appearance.value.faceFeatures = faceFeatures
    fetchNui('appearance_change_face_feature', faceFeatures)
  }

  // ── Head Overlays ──
  function changeHeadOverlays(headOverlays: HeadOverlays) {
    if (!appearance.value) return
    appearance.value.headOverlays = headOverlays
    fetchNui('appearance_change_head_overlay', headOverlays)
  }

  // ── Hair ──
  async function changeHair(hair: HairValue) {
    if (!appearance.value) return
    appearance.value.hair = hair
    const res = await fetchNui('appearance_change_hair', hair)
    if (res && settings.value) {
      settings.value.hair = res
    }
  }

  // ── Fade (ZONE_HAIR tattoo) ──
  // Goes through setPedTattoos -> updates PED_TATTOOS -> fade survives a hair change
  async function changeFade(fadeIndex: number) {
    if (!appearance.value || !settings.value) return
    const fadeItems = settings.value.tattoos?.items?.['ZONE_HAIR'] ?? []
    if (!fadeItems.length || fadeIndex < 0 || fadeIndex >= fadeItems.length) return
    const tattoo = fadeItems[fadeIndex]
    const updatedTattoos = { ...appearance.value.tattoos }
    updatedTattoos['ZONE_HAIR'] = [tattoo]
    await fetchNui('appearance_change_fade', updatedTattoos)
    appearance.value.tattoos = updatedTattoos
  }

  // ── Fade Opacity ──
  async function changeFadeOpacity(opacity: number) {
    if (!appearance.value) return
    const zoneHair = appearance.value.tattoos?.['ZONE_HAIR']
    if (!zoneHair?.length) return
    const updatedTattoos = { ...appearance.value.tattoos }
    updatedTattoos['ZONE_HAIR'] = [{ ...zoneHair[0], opacity }]
    await fetchNui('appearance_change_fade', updatedTattoos)
    appearance.value.tattoos = updatedTattoos
  }

  // ── Eye Color ──
  function changeEyeColor(color: number) {
    if (!appearance.value) return
    appearance.value.eyeColor = color
    fetchNui('appearance_change_eye_color', color)
  }

  // ── Components ──
  async function changeComponent(component: ComponentValue) {
    if (!appearance.value) return
    const idx = appearance.value.components.findIndex(
      (c) => c.component_id === component.component_id
    )
    if (idx !== -1) {
      appearance.value.components[idx] = component
    }
    const res = await fetchNui('appearance_change_component', component)
    if (res && settings.value) {
      const sIdx = settings.value.components.findIndex(
        (c) => c.component_id === component.component_id
      )
      if (sIdx !== -1) {
        settings.value.components[sIdx] = res
      }
    }
  }

  // ── Props ──
  async function changeProp(prop: PropValue) {
    if (!appearance.value) return
    const idx = appearance.value.props.findIndex((p) => p.prop_id === prop.prop_id)
    if (idx !== -1) {
      appearance.value.props[idx] = prop
    }
    const res = await fetchNui('appearance_change_prop', prop)
    if (res && settings.value) {
      const sIdx = settings.value.props.findIndex((p) => p.prop_id === prop.prop_id)
      if (sIdx !== -1) {
        settings.value.props[sIdx] = res
      }
    }
  }

  // ── Tattoos ──
  async function applyTattoo(tattoo: TattooItem, updatedTattoos: Record<TattooZone, TattooItem[]>) {
    const paid = await fetchNui<boolean>('appearance_apply_tattoo', { tattoo, updatedTattoos })
    if (paid && appearance.value) {
      appearance.value.tattoos = updatedTattoos
    }
    return paid
  }

  function previewTattoo(data: Record<TattooZone, TattooItem[]>, tattoo: TattooItem) {
    fetchNui('appearance_preview_tattoo', { data, tattoo })
  }

  function deleteTattoo(tattoos: Record<TattooZone, TattooItem[]>) {
    if (!appearance.value) return
    appearance.value.tattoos = tattoos
    fetchNui('appearance_delete_tattoo', tattoos)
  }

  // Re-apply tattoos table without payment (used for opacity edits on already-applied tattoos)
  function updateTattoos(tattoos: Record<TattooZone, TattooItem[]>) {
    if (!appearance.value) return
    appearance.value.tattoos = tattoos
    fetchNui('appearance_delete_tattoo', tattoos)
  }

  // ── Clothes ──
  function wearClothes(data: any, key: 'head' | 'body' | 'bottom') {
    fetchNui('appearance_wear_clothes', { data, key })
  }

  function removeClothes(clothesType: string) {
    fetchNui('appearance_remove_clothes', clothesType)
  }

  // ── Save / Exit ──
  function save() {
    if (!appearance.value) return
    // Validate appearance has required fields before saving
    if (!appearance.value.model || appearance.value.model === '') {
      console.error('[appearance] Cannot save: missing model')
      return
    }
    if (!appearance.value.components || appearance.value.components.length === 0) {
      console.error('[appearance] Cannot save: missing components')
      return
    }
    if (!appearance.value.props || appearance.value.props.length === 0) {
      console.error('[appearance] Cannot save: missing props')
      return
    }
    fetchNui('appearance_save', appearance.value)
    hide()
  }

  function exit() {
    fetchNui('appearance_exit')
    hide()
  }

  async function preloadAssets(type: 'components' | 'props' | 'hair') {
    if (isPreloading.value || !appearance.value || !settings.value) return
    
    // Check if we are resuming the same type
    const isResuming = preloadState.value.type === type && preloadState.value.lastDrawable !== -2
    
    isPreloading.value = true
    cancelPreload.value = false

    if (!isResuming) {
      preloadProgress.value = 0
      preloadItem.value = ''
      preloadState.value = {
        type,
        lastItemIndex: 0,
        lastDrawable: -2,
        currentStep: 0,
        totalSteps: 0
      }
    }

    const items = (type === 'components' || type === 'hair') ? settings.value.components : settings.value.props
    const originalData = JSON.parse(JSON.stringify(appearance.value))
    
    let filteredItems: any[] = []
    if (type === 'hair') {
      filteredItems = [{
        isHair: true,
        drawable: {
          min: settings.value.hair.style.min,
          max: settings.value.hair.style.max
        }
      }]
    } else {
      filteredItems = items.filter(item => {
        if (type === 'components') {
          const id = (item as any).component_id
          if (id === 0 || id === 2) return false
          const mapping: Record<number, string | undefined> = {
            1: 'masks', 3: 'upperBody', 4: 'lowerBody', 5: 'bags', 6: 'shoes',
            7: 'scarfAndChains', 8: 'shirts', 9: 'bodyArmor', 10: 'decals', 11: 'jackets'
          }
          const key = mapping[id]
          return key ? (config.value.componentConfig as any)[key] !== false : true
        }
        if (type === 'props') {
          const id = (item as any).prop_id
          const mapping: Record<number, string | undefined> = {
            0: 'hats', 1: 'glasses', 2: 'ear', 6: 'watches', 7: 'bracelets'
          }
          const key = mapping[id]
          return key ? (config.value.propConfig as any)[key] !== false : true
        }
        return true
      })

      // Sort filteredItems to match the UI display order (front-to-back)
      if (type === 'components') {
        const order = [11, 8, 3, 4, 6, 10, 1, 9, 5, 7]
        filteredItems.sort((a, b) => {
          const ai = order.indexOf((a as any).component_id)
          const bi = order.indexOf((b as any).component_id)
          return (ai === -1 ? 999 : ai) - (bi === -1 ? 999 : bi)
        })
      } else if (type === 'props') {
        const order = [0, 1, 2, 6, 7]
        filteredItems.sort((a, b) => {
          const ai = order.indexOf((a as any).prop_id)
          const bi = order.indexOf((b as any).prop_id)
          return (ai === -1 ? 999 : ai) - (bi === -1 ? 999 : bi)
        })
      }
    }

    if (!isResuming) {
      let total = 0
      filteredItems.forEach(item => {
        total += (item.drawable.max - item.drawable.min + 1)
      })
      preloadState.value.totalSteps = total
    }

    try {
      for (let i = preloadState.value.lastItemIndex; i < filteredItems.length; i++) {
        const item = filteredItems[i]
        preloadState.value.lastItemIndex = i
        
        // Update item label
        if (type === 'components' || type === 'hair') {
          const id = (item as any).component_id
          const keys: Record<number, string> = {
            0: 'components.head', 1: 'components.mask', 2: 'headOverlays.hair.title', 3: 'components.upperBody',
            4: 'components.lowerBody', 5: 'components.bags', 6: 'components.shoes', 7: 'components.scarfAndChains',
            8: 'components.shirt', 9: 'components.bodyArmor', 10: 'components.decals', 11: 'components.jackets'
          }
          preloadItem.value = t(keys[id] || 'components.title')
        } else {
          const id = (item as any).prop_id
          const keys: Record<number, string> = {
            0: 'props.hats', 1: 'props.glasses', 2: 'props.ear', 6: 'props.watches', 7: 'props.bracelets'
          }
          preloadItem.value = t(keys[id] || 'props.title')
        }

        const startD = (isResuming && i === preloadState.value.lastItemIndex && preloadState.value.lastDrawable !== -2) 
          ? preloadState.value.lastDrawable + 1 
          : item.drawable.min

        for (let d = startD; d <= item.drawable.max; d++) {
          if (cancelPreload.value) {
            preloadState.value.lastDrawable = d - 1
            throw new Error('Canceled')
          }
          
          if (item.isHair) {
             await changeHair({ ...originalData.hair, style: d })
          } else if (type === 'components') {
             await changeComponent({ component_id: (item as any).component_id, drawable: d, texture: 0 })
          } else {
             await changeProp({ prop_id: (item as any).prop_id, drawable: d, texture: 0 })
          }

          // Check again after async NUI call so progress is never updated after cancel
          if (cancelPreload.value) {
            preloadState.value.lastDrawable = d
            throw new Error('Canceled')
          }

          preloadState.value.currentStep++
          preloadProgress.value = Math.round((preloadState.value.currentStep / preloadState.value.totalSteps) * 100)
          await new Promise(resolve => setTimeout(resolve, 35))
        }
      }
      
      // Finished
      preloadState.value.lastDrawable = -2 // Mark as finished
      preloadProgress.value = 100
      setTimeout(() => { preloadProgress.value = 0 }, 2000)
    } catch (e) {
      // Hard stop (Cancel): preloadProgress was set to 0 by stopPreload → reset state for a fresh start next time
      if (preloadProgress.value === 0) {
        preloadState.value = { type: null, lastItemIndex: 0, lastDrawable: -2, currentStep: 0, totalSteps: 0 }
      }
      console.log('Preload paused or failed', e)
    } finally {
      // Restore original look
      appearance.value = originalData
      if (type === 'hair') {
        fetchNui('appearance_change_hair', originalData.hair)
      } else if (type === 'components') {
        for (const c of originalData.components) fetchNui('appearance_change_component', c)
      } else {
        for (const p of originalData.props) fetchNui('appearance_change_prop', p)
      }
      isPreloading.value = false
    }
  }

  function stopPreload() {
    cancelPreload.value = true
    isPreloading.value = false
    preloadProgress.value = 0
  }

  function pausePreload() {
    cancelPreload.value = true
  }

  function updateLightConfig(config: Partial<typeof lightConfig.value>) {
    lightConfig.value = { ...lightConfig.value, ...config }
    if (lightConfig.value.active) {
      fetchNui('appearance_update_light', lightConfig.value)
    }
  }


  return {
    // state
    isVisible,
    isLoading,
    isReady,
    isOutfitsPanelOpen,
    isLightPanelOpen,
    isPreloading,
    isPaused,
    preloadProgress,
    preloadItem,
    isFilterFavoritesActive,
    activeTab,
    activeCamera,
    activeRotation,
    locales,
    settings,
    config,
    appearance,
    originalAppearance,
    lightConfig,

    // computed
    hasChanges,
    availableTabs,
    // methods
    t,
    getVisibleSections,
    init,
    show,
    hide,
    setCamera,
    turnAround,
    rotateLeft,
    rotateRight,
    changeModel,
    changeHeadBlend,
    changeFaceFeatures,
    changeHeadOverlays,
    changeHair,
    updateLightConfig,

    changeFade,
    changeFadeOpacity,
    changeEyeColor,
    changeComponent,
    changeProp,
    applyTattoo,
    previewTattoo,
    deleteTattoo,
    updateTattoos,
    wearClothes,
    removeClothes,
    stopPreload,
    pausePreload,
    preloadAssets,
    save,
    exit,
  }
})
