#!/bin/bash

# Script de corrección inmediata para eliminar sintaxis TypeScript
# AnuSet Desktop v4.2.1 - Corrección urgente

set -e

echo "🔧 CORRECCIÓN TYPESCRIPT - ANUSET DESKTOP v4.2.1"
echo "================================================"

# Verificar que estamos en el directorio correcto
if [[ ! -f "package.json" ]]; then
    echo "❌ Error: No se encontró package.json"
    echo "📍 Ejecuta este script desde: /opt/anuset-vtuber-desktop/"
    exit 1
fi

echo "📁 Aplicando corrección JavaScript puro..."

# Crear respaldo
cp src/App.jsx src/App.jsx.backup 2>/dev/null || true

# Crear App.jsx corregido - JavaScript puro
cat > src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { AvatarProvider } from './contexts/AvatarContext';
import { StreamingProvider } from './contexts/StreamingContext';
import { ConfigProvider } from './contexts/ConfigContext';
import { setupDatabase } from './utils/database';
import { setupGeminiService } from './utils/geminiService';
import { LoginForm } from './components/LoginForm';
import { ChatAvatar } from './components/ChatAvatar';
import Layout from './components/Layout';
import Dashboard from './components/Dashboard';
import Settings from './components/Settings';
import './App.css';

// Componente para rutas protegidas (JavaScript puro)
const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, isLoading } = useAuth();
  
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 flex items-center justify-center">
        <div className="text-center text-purple-400">
          <div className="animate-spin w-8 h-8 border-2 border-purple-400 border-t-transparent rounded-full mx-auto mb-4"></div>
          <h2 className="text-xl mb-2">Cargando AnuSet Desktop</h2>
          <p className="text-sm">Inicializando sistema VTuber IA...</p>
          <p className="text-xs text-purple-500 mt-2">✨ v4.2.1</p>
        </div>
      </div>
    );
  }
  
  if (!isAuthenticated) {
    return <LoginForm />;
  }
  
  return <>{children}</>;
};

// Componente principal de la aplicación
const AppContent = () => {
  const { isAuthenticated, isLoading } = useAuth();

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 flex items-center justify-center">
        <div className="text-center text-purple-400">
          <div className="animate-spin w-8 h-8 border-2 border-purple-400 border-t-transparent rounded-full mx-auto mb-4"></div>
          <h2 className="text-xl mb-2">Cargando AnuSet Desktop</h2>
          <p className="text-sm">Inicializando sistema VTuber IA...</p>
          <p className="text-xs text-purple-500 mt-2">✨ v4.2.1</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return <LoginForm />;
  }

  return (
    <div className="app min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <Router>
        <Routes>
          <Route 
            path="/" 
            element={
              <Layout>
                <ChatAvatar />
              </Layout>
            } 
          />
          <Route 
            path="/dashboard" 
            element={
              <Layout>
                <Dashboard />
              </Layout>
            } 
          />
          <Route 
            path="/settings" 
            element={
              <Layout>
                <Settings />
              </Layout>
            } 
          />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </Router>
    </div>
  );
};

function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [initError, setInitError] = useState(null);

  useEffect(() => {
    // Inicializar la aplicación
    const initApp = async () => {
      try {
        console.log('🚀 Inicializando AnuSet Desktop...');
        
        // Inicializar base de datos
        console.log('📁 Conectando base de datos SQLite...');
        await setupDatabase();
        console.log('✅ Base de datos SQLite conectada');
        
        // Inicializar servicio Gemini
        console.log('🤖 Configurando Gemini API local...');
        await setupGeminiService();
        console.log('✅ Gemini API configurada');
        
        // Simular tiempo de carga
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        setIsLoading(false);
        console.log('🎉 AnuSet Desktop listo');
        
      } catch (error) {
        console.error('❌ Error al inicializar la aplicación:', error);
        setInitError(error.message || 'Error desconocido');
        setIsLoading(false);
      }
    };

    initApp();
  }, []);

  // Pantalla de carga
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 flex items-center justify-center">
        <div className="text-center text-purple-400">
          <div className="mb-8">
            <h1 className="text-4xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-600 mb-4">
              AnuSet
            </h1>
            <p className="text-purple-300 text-lg">Sistema VTuber IA Desktop</p>
            <p className="text-purple-500 text-sm">v4.2.1 - JavaScript Puro</p>
          </div>
          
          <div className="animate-spin w-12 h-12 border-2 border-purple-400 border-t-transparent rounded-full mx-auto mb-6"></div>
          
          <div className="space-y-2 text-sm">
            <p>🖥️ Modo Desktop - 100% Offline</p>
            <p>🔒 Base de datos SQLite local</p>
            <p>🤖 Gemini API integrada</p>
            <p>🎭 Avatar 3D con Three.js</p>
          </div>
          
          {initError && (
            <div className="mt-6 p-4 bg-red-500/20 border border-red-500 text-red-200 rounded-lg max-w-md">
              <p className="font-bold">Error de inicialización:</p>
              <p className="text-xs mt-1">{initError}</p>
            </div>
          )}
        </div>
      </div>
    );
  }

  return (
    <AuthProvider>
      <ConfigProvider>
        <AvatarProvider>
          <StreamingProvider>
            <AppContent />
          </StreamingProvider>
        </AvatarProvider>
      </ConfigProvider>
    </AuthProvider>
  );
}

export default App;
EOF

echo "✅ App.jsx corregido - JavaScript puro aplicado"

# Limpiar caché de node_modules para evitar conflictos
echo "🧹 Limpiando caché..."
rm -rf node_modules/.vite
rm -rf dist
rm -rf .vite

echo "🔄 Reinstalando dependencias con configuración compatible..."
npm install --legacy-peer-deps

echo "✅ CORRECCIÓN COMPLETADA"
echo "🚀 Ahora puedes ejecutar: npm run dev"
echo ""
echo "📋 Verificaciones:"
echo "  • Sintaxis TypeScript eliminada ✅"
echo "  • JavaScript puro aplicado ✅" 
echo "  • Dependencias reinstaladas ✅"
echo "  • Caché limpio ✅"
echo ""
echo "🎯 Ejecuta ahora: npm run dev"