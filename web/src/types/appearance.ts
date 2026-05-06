// ── Appearance Data Types ──

export interface HeadBlend {
  shapeFirst: number
  shapeSecond: number
  shapeThird: number
  skinFirst: number
  skinSecond: number
  skinThird: number
  shapeMix: number
  skinMix: number
  thirdMix: number
}

export interface FaceFeatures {
  noseWidth: number
  nosePeakHigh: number
  nosePeakSize: number
  noseBoneHigh: number
  nosePeakLowering: number
  noseBoneTwist: number
  eyeBrownHigh: number
  eyeBrownForward: number
  cheeksBoneHigh: number
  cheeksBoneWidth: number
  cheeksWidth: number
  eyesOpening: number
  lipsThickness: number
  jawBoneWidth: number
  jawBoneBackSize: number
  chinBoneLowering: number
  chinBoneLenght: number
  chinBoneSize: number
  chinHole: number
  neckThickness: number
}

export interface HeadOverlayValue {
  style: number
  opacity: number
  color?: number
  secondColor?: number
}

export type HeadOverlays = {
  blemishes: HeadOverlayValue
  beard: HeadOverlayValue
  eyebrows: HeadOverlayValue
  ageing: HeadOverlayValue
  makeUp: HeadOverlayValue
  blush: HeadOverlayValue
  complexion: HeadOverlayValue
  sunDamage: HeadOverlayValue
  lipstick: HeadOverlayValue
  moleAndFreckles: HeadOverlayValue
  chestHair: HeadOverlayValue
  bodyBlemishes: HeadOverlayValue
}

export interface ComponentValue {
  component_id: number
  drawable: number
  texture: number
}

export interface PropValue {
  prop_id: number
  drawable: number
  texture: number
}

export interface HairValue {
  style: number
  color: number
  highlight: number
  texture: number
}

export interface TattooItem {
  name: string
  label?: string
  collection: string
  hashMale: string
  hashFemale: string
  opacity?: number
  zone?: string
  cost?: number
}

export type TattooZone = 'ZONE_TORSO' | 'ZONE_HEAD' | 'ZONE_LEFT_ARM' | 'ZONE_RIGHT_ARM' | 'ZONE_LEFT_LEG' | 'ZONE_RIGHT_LEG' | 'ZONE_HAIR'

export interface AppearanceData {
  model: string
  headBlend: HeadBlend
  faceFeatures: FaceFeatures
  headOverlays: HeadOverlays
  components: ComponentValue[]
  props: PropValue[]
  hair: HairValue
  eyeColor: number
  tattoos: Record<string, TattooItem[]>
}

// ── Settings Types (ranges/options for UI) ──

export interface RangeSetting {
  min: number
  max: number
  factor?: number
}

export interface BlacklistSetting {
  drawables?: number[]
  textures?: number[]
}

export interface ComponentSetting {
  component_id: number
  drawable: RangeSetting
  texture: RangeSetting
  blacklist?: BlacklistSetting
}

export interface PropSetting {
  prop_id: number
  drawable: RangeSetting
  texture: RangeSetting
  blacklist?: BlacklistSetting
}

export interface OverlaySetting {
  style: RangeSetting
  opacity: RangeSetting
  color?: { items: number[][] }
}

export interface HairSetting {
  style: RangeSetting
  color: { items: number[][] }
  highlight: { items: number[][] }
  texture: RangeSetting
  blacklist?: BlacklistSetting
}

export interface PedModelItem {
  model: string
  label?: string
}

export interface AppearanceSettings {
  ped: {
    model: {
      items: PedModelItem[]
    }
  }
  components: ComponentSetting[]
  props: PropSetting[]
  headBlend: Record<string, RangeSetting>
  faceFeatures: Record<string, RangeSetting>
  headOverlays: Record<string, OverlaySetting>
  hair: HairSetting
  eyeColor: RangeSetting
  tattoos: {
    items: Record<string, TattooItem[]>
    opacity: RangeSetting
  }
}

// ── Session Config (from Lua GetDefaultConfig) ──

export interface ComponentConfig {
  masks: boolean
  upperBody: boolean
  lowerBody: boolean
  bags: boolean
  shoes: boolean
  scarfAndChains: boolean
  shirts: boolean
  bodyArmor: boolean
  decals: boolean
  jackets: boolean
}

export interface PropConfig {
  hats: boolean
  glasses: boolean
  ear: boolean
  watches: boolean
  bracelets: boolean
}

export interface SessionConfig {
  ped: boolean
  headBlend: boolean
  faceFeatures: boolean
  headOverlays: boolean
  components: boolean
  componentConfig: ComponentConfig
  props: boolean
  propConfig: PropConfig
  tattoos: boolean
  enableExit: boolean
  hasTracker: boolean
  automaticFade: boolean
  clothingToggles?: {
    male: { jacketSentinel: number; undershirtSentinel: number; torsoSentinel: number; lowerSentinel: number; shoesSentinel: number; hatSentinel: number; maskSentinel: number; glassesSentinel?: number }
    female: { jacketSentinel: number; undershirtSentinel: number; torsoSentinel: number; lowerSentinel: number; shoesSentinel: number; hatSentinel: number; maskSentinel: number; glassesSentinel?: number }
  }
  shopType?: 'ponsonbys' | 'binco' | 'suburban' | 'barber' | 'tattoo' | 'creator' | 'wardrobe' | string
  tattooCost?: number
  chargePerTattoo?: boolean
  theme?: {
    accentColor?: string
    panelBackground?: string
    headerBackground?: string
  }
  // Centralized UI config sourced from shared/config.lua → Config.UI
  uiConfig?: UIConfig
  [key: string]: unknown
}

export interface UIThemeEntry {
  accent?: string
  accentRgb?: string
  fontSans?: string
  fontDisplay?: string
  panelBaseHex?: string
  panelOpacity?: number
  panelBlur?: number
  roundedPanel?: string
  roundedCard?: string
  textPrimary?: string
  textSecondary?: string
  textMuted?: string
}

export interface UIConfig {
  themes?: Record<string, UIThemeEntry>
  tabs?: Record<string, TabId[]>
  sections?: Record<string, string[]>
}

// ── Locale Types ──

export type LocaleData = Record<string, any>

// ── Tab Configuration ──

export type TabId = 'model' | 'heritage' | 'face' | 'appearance' | 'hair' | 'clothing' | 'accessories' | 'tattoos'

export interface TabConfig {
  id: TabId
  localeKey: string
  camera: string
}
