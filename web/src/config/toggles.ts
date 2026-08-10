/**
 * ═══════════════════════════════════════════
 *  CLOTHING TOGGLE CONFIG
 *  Sentinel values for the clothing remove/wear buttons.
 *
 *  Sentinel = the drawable ID that means "nothing worn".
 *  Example: 15 for a jacket = "no jacket" (bare torso).
 *
 *  Configurable separately for male (mp_m_freemode_01)
 *  and female (mp_f_freemode_01).
 *
 *  How to find them?
 *  - Remove the item in game and check the current drawable value.
 *  - Usually: jacket=15, legs=15, hat=-1 (props use -1 to remove).
 * ═══════════════════════════════════════════
 */

export interface ClothingToggleConfig {
  /** component_id: 11 - jacket / outerwear */
  jacketSentinel: number
  /** component_id: 4 - legs / pants */
  lowerSentinel: number
  /** prop_id: 0 - hat (always -1 to remove a prop, do not change) */
  hatRemovedDrawable: -1
}

const MALE_CONFIG: ClothingToggleConfig = {
  jacketSentinel: 15,   // Male - no jacket
  lowerSentinel: 15,    // Male - no legs
  hatRemovedDrawable: -1,
}

const FEMALE_CONFIG: ClothingToggleConfig = {
  jacketSentinel: 15,   // Female - no jacket (change if different)
  lowerSentinel: 15,    // Female - no legs (change if different)
  hatRemovedDrawable: -1,
}

/**
 * Returns the right config for a model name.
 * FiveM ped models: mp_m_freemode_01 (male), mp_f_freemode_01 (female)
 */
export function getToggleConfig(model: string | null | undefined): ClothingToggleConfig {
  if (model && model.toLowerCase().includes('_f_')) {
    return FEMALE_CONFIG
  }
  return MALE_CONFIG
}
