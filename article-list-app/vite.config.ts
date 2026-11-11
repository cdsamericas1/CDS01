import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    // Carbon v11 uses @position-try which is not yet supported by the
    // bundled lightningcss version in Vite 8 — disable CSS minification
    cssMinify: false,
  },
})
