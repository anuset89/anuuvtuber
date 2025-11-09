import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { nodePolyfills } from 'vite-plugin-node-polyfills';
import path from 'path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    nodePolyfills({
      protocolImports: true,
    })
  ],
  
  // Configuración de servidor de desarrollo
  server: {
    port: 3000,
    host: true,
    open: false,
    strictPort: true
  },

  // Configuración de build optimizada
  build: {
    outDir: 'dist',
    sourcemap: true,
    minify: 'esbuild',
    target: 'es2020',
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          three: ['three', '@pixiv/three-vrm'],
          router: ['react-router-dom'],
          ui: ['lucide-react']
        }
      }
    }
  },

  // Configuración de resolución de módulos
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
      '@/components': path.resolve(__dirname, 'src/components'),
      '@/utils': path.resolve(__dirname, 'src/utils'),
      '@/hooks': path.resolve(__dirname, 'src/hooks'),
      '@/contexts': path.resolve(__dirname, 'src/contexts'),
      '@/assets': path.resolve(__dirname, 'assets'),
      '@/config': path.resolve(__dirname, 'config')
    }
  },

  // Configuración de CSS
  css: {
    modules: {
      localsConvention: 'camelCase'
    }
  },

  // Configuración de optimizaciones
  optimizeDeps: {
    include: [
      'react',
      'react-dom',
      'react-router-dom',
      'three',
      '@pixiv/three-vrm',
      'axios',
      'sqlite3',
      '@google/generative-ai'
    ]
  },

  // Configuración para Electron/Desktop
  base: './',
  
  // Configuración de definición de variables de entorno
  define: {
    __DEV__: JSON.stringify(process.env.NODE_ENV === 'development')
  },

  // Configuración de worker para soporte offline
  worker: {
    format: 'es'
  }
});