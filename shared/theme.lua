-- ════════════════════════════════════════════════════════════════════
-- 🎨 SHOPPING TYPE THEME CONFIGURATION
-- ════════════════════════════════════════════════════════════════════
-- Visual style per shopType. Edit any value to reskin that shop.
--
-- accent        : Primary accent color (hex)
-- accentRgb     : Same color as "R, G, B" (required for rgba usage)
-- fontSans      : Body / UI font name (Google Fonts)
-- fontDisplay   : Heading / display font name (Google Fonts)
-- panelBaseHex  : Panel background color before opacity is applied
-- panelOpacity  : Panel opacity  0.0 (transparent) → 1.0 (solid)
-- panelBlur     : Backdrop blur amount in pixels
-- roundedPanel  : Border radius of main panels  (e.g. "1.5rem")
-- roundedCard   : Border radius of inner cards  (e.g. "1rem")
-- textPrimary   : Primary text color
-- textSecondary : Secondary / accent text color
-- textMuted     : Muted / hint text color
-- ════════════════════════════════════════════════════════════════════

Config.UI.Themes = {
    -- ── Character creator ──────────────────────────────────────────
    creator = {
        accent        = "#ff3131",
        accentRgb     = "255, 49, 49",
        fontSans      = "Outfit",
        fontDisplay   = "Rajdhani",
        panelBaseHex  = "#080808",
        panelOpacity  = 0.75,
        panelBlur     = 18,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#ffffff",
        textSecondary = "#d4d4d8",
        textMuted     = "#71717a",
    },
    -- ── Clothing stores ────────────────────────────────────────────
    ponsonbys = {
        accent        = "#d4af37",
        accentRgb     = "212, 175, 55",
        fontSans      = "Outfit",
        fontDisplay   = "Metamorphous",
        panelBaseHex  = "#050505",
        panelOpacity  = 0.75,
        panelBlur     = 22,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#f8fafc",
        textSecondary = "#9ca3af",
        textMuted     = "#6b7280",
    },
    binco = {
        accent        = "#22c55e",
        accentRgb     = "34, 197, 94",
        fontSans      = "Inter",
        fontDisplay   = "Indie Flower",
        panelBaseHex  = "#0a0a0a",
        panelOpacity  = 0.75,
        panelBlur     = 16,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#ffffff",
        textSecondary = "#f97316",
        textMuted     = "#9ca3af",
    },
    suburban = {
        accent        = "#3b82f6",
        accentRgb     = "59, 130, 246",
        fontSans      = "Roboto",
        fontDisplay   = "Staatliches",
        panelBaseHex  = "#0a0c10",
        panelOpacity  = 0.75,
        panelBlur     = 18,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#f8fafc",
        textSecondary = "#eab308",
        textMuted     = "#9ca3af",
    },
    -- ── Service shops ──────────────────────────────────────────────
    barber = {
        accent        = "#d97706",
        accentRgb     = "217, 119, 6",
        fontSans      = "Outfit",
        fontDisplay   = "Abril Fatface",
        panelBaseHex  = "#0f0a08",
        panelOpacity  = 0.78,
        panelBlur     = 18,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#fff7ed",
        textSecondary = "#d6d3d1",
        textMuted     = "#78716c",
    },
    tattoo = {
        accent        = "#dc2626",
        accentRgb     = "220, 38, 38",
        fontSans      = "Outfit",
        fontDisplay   = "Pirata One",
        panelBaseHex  = "#050505",
        panelOpacity  = 0.78,
        panelBlur     = 20,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#f1f5f9",
        textSecondary = "#fb923c",
        textMuted     = "#a1a1aa",
    },
    surgeon = {
        accent        = "#06b6d4",
        accentRgb     = "6, 182, 212",
        fontSans      = "Inter",
        fontDisplay   = "Rajdhani",
        panelBaseHex  = "#020d12",
        panelOpacity  = 0.82,
        panelBlur     = 20,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#ecfeff",
        textSecondary = "#a5f3fc",
        textMuted     = "#64748b",
    },
    -- ── Outfit / clothing rooms ─────────────────────────────────────
    clothingroom = {
        accent        = "#6366f1",
        accentRgb     = "99, 102, 241",
        fontSans      = "Outfit",
        fontDisplay   = "Rajdhani",
        panelBaseHex  = "#08080f",
        panelOpacity  = 0.80,
        panelBlur     = 18,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#f8fafc",
        textSecondary = "#c7d2fe",
        textMuted     = "#6b7280",
    },
    playeroutfitroom = {
        accent        = "#14b8a6",
        accentRgb     = "20, 184, 166",
        fontSans      = "Outfit",
        fontDisplay   = "Rajdhani",
        panelBaseHex  = "#0f0a19",
        panelOpacity  = 0.75,
        panelBlur     = 18,
        roundedPanel  = "1.5rem",
        roundedCard   = "1rem",
        textPrimary   = "#ffffff",
        textSecondary = "#5eead4",
        textMuted     = "#a3a3a3",
    },
}

-- ════════════════════════════════════════════════════════════════════
-- 🖌️  CUSTOM THEMES  (add your own shop themes here)
-- ════════════════════════════════════════════════════════════════════
-- Each key should match the shopType value you use in Config.Stores
-- (e.g. shopType = "mymall"). Keys defined here OVERRIDE the
-- built-in themes above if the names collide.
--
-- Example:
--   mymall = {
--       accent        = "#e879f9",
--       accentRgb     = "232, 121, 249",
--       fontSans      = "Outfit",
--       fontDisplay   = "Rajdhani",
--       panelBaseHex  = "#130a1a",
--       panelOpacity  = 0.80,
--       panelBlur     = 18,
--       roundedPanel  = "1.5rem",
--       roundedCard   = "1rem",
--       textPrimary   = "#ffffff",
--       textSecondary = "#f0abfc",
--       textMuted     = "#a1a1aa",
--   },
-- ════════════════════════════════════════════════════════════════════
Config.UI.CustomThemes = {
    -- Add your custom themes here
}

-- Auto-merge CustomThemes into the main Themes table.
-- Custom entries override built-in ones with the same key.
for k, v in pairs(Config.UI.CustomThemes) do
    Config.UI.Themes[k] = v
end
