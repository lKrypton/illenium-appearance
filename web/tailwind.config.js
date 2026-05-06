/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--theme-font-sans)', 'sans-serif'],
        display: ['var(--theme-font-display)', 'sans-serif'],
      },
      colors: {
        theme: {
          base: 'var(--theme-bg-base)',
          card: {
            DEFAULT: 'var(--theme-bg-card)',
            hover: 'var(--theme-bg-card-hover)',
            active: 'var(--theme-bg-card-active)',
          },
          accent: 'var(--theme-accent)',
          text: {
            primary: 'var(--theme-text-primary)',
            secondary: 'var(--theme-text-secondary)',
            muted: 'var(--theme-text-muted)',
          },
          border: 'var(--theme-border-base)',
        }
      },
      borderRadius: {
        'theme-panel': 'var(--theme-border-radius-panel)',
        'theme-card': 'var(--theme-border-radius-card)',
      }
    },
  },
  plugins: [],
}
