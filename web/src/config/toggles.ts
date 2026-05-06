/**
 * ═══════════════════════════════════════════
 *  CLOTHING TOGGLE CONFIG
 *  Kıyafet çıkar/tak butonlarının sentinel değerleri.
 *
 *  Sentinel = "kıyafet yok" anlamına gelen drawable ID.
 *  Örneğin: ceket için 15 = "ceketsiz görünüm" (çıplak üst)
 *
 *  Erkek (mp_m_freemode_01) ve kadın (mp_f_freemode_01)
 *  için ayrı ayrı ayarlayabilirsin.
 *
 *  Nasıl bulunur?
 *  - Oyunda kıyafeti çıkar, o anda giyili olan drawable değerini bak.
 *  - Genelde: ceket=15, alt=15, şapka=-1 (prop çıkarmak için -1 kullanılır)
 * ═══════════════════════════════════════════
 */

export interface ClothingToggleConfig {
  /** component_id: 11 — Ceket / Dış Giysi */
  jacketSentinel: number
  /** component_id: 4 — Alt Giysi / Pantolon */
  lowerSentinel: number
  /** prop_id: 0 — Şapka (prop çıkarmak için her zaman -1, değiştirme) */
  hatRemovedDrawable: -1
}

const MALE_CONFIG: ClothingToggleConfig = {
  jacketSentinel: 15,   // Erkek - ceket yok
  lowerSentinel: 15,    // Erkek - pantolon yok
  hatRemovedDrawable: -1,
}

const FEMALE_CONFIG: ClothingToggleConfig = {
  jacketSentinel: 15,   // Kadın - ceket yok (değiştir eğer farklıysa)
  lowerSentinel: 15,    // Kadın - pantolon yok (değiştir eğer farklıysa)
  hatRemovedDrawable: -1,
}

/**
 * Model adına göre doğru config'i döner.
 * FiveM ped modelleri: mp_m_freemode_01 (erkek), mp_f_freemode_01 (kadın)
 */
export function getToggleConfig(model: string | null | undefined): ClothingToggleConfig {
  if (model && model.toLowerCase().includes('_f_')) {
    return FEMALE_CONFIG
  }
  return MALE_CONFIG
}
