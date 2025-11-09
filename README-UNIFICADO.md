# 🎭 AnuSet Desktop v4.2.1 - Aplicación VTuber IA Optimizada

## 📖 Descripción

**AnuSet Desktop** es una aplicación VTuber profesional con inteligencia artificial integrada, avatar 3D interactivo y capacidades de chat inteligente. Diseñada para funcionar 100% offline con una interfaz moderna y características avanzadas.

## ✨ Características Principales

### 🎭 **Avatar 3D Interactivo**
- Renderizado con Three.js optimizado (v0.164.1)
- Soporte completo para archivos VRM
- Animaciones fluidas y expresiones faciales
- Controles de cámara y iluminación

### 🤖 **Chat IA Avanzado**
- Integración con Gemini AI
- Múltiples personalidades configurables
- Respuestas inteligentes en tiempo real
- Historial de conversación persistente

### 🎤 **Sistema TTS (Text-to-Speech)**
- Síntesis de voz natural
- Múltiples voces disponibles
- Configuración de velocidad y tono
- Integración con avatar 3D

### 💾 **Almacenamiento Local**
- Base de datos SQLite integrada
- Sin dependencia de servidores externos
- Configuraciones persistentes
- Sistema de backup automático

### 🖥️ **Aplicación Desktop**
- Arquitectura React + Vite optimizada
- Interfaz responsive y moderna
- Soporte multiplataforma
- Instalación automática

## 🔧 Requisitos del Sistema

### **Requerimientos Mínimos**
- **OS**: Windows 10+, macOS 10.14+, Linux (Arch, Debian, Ubuntu)
- **RAM**: 4GB mínimo, 8GB recomendado
- **CPU**: Procesador de 64 bits
- **Espacio**: 1GB de espacio libre
- **Node.js**: 18.0+ (se instala automáticamente)
- **NPM**: 8.0+ (se instala automáticamente)

### **Requerimientos Recomendados**
- **RAM**: 8GB o más
- **GPU**: Soporte para WebGL 2.0
- **Conexión**: Internet para configuración inicial (opcional)

## 🚀 Instalación Rápida

### **Opción 1: Instalación Automática (Recomendada)**

#### **Linux (Arch/Debian/Ubuntu)**
```bash
# Descargar y extraer
wget https://github.com/tu-repo/anuset-desktop/releases/latest/download/AnuSet-Desktop-Optimized.zip
unzip AnuSet-Desktop-Optimized.zip
cd anuset-vtuber-desktop-optimized/

# Instalar automáticamente
sudo chmod +x INSTALAR-OPTIMIZADO.sh
sudo ./INSTALAR-OPTIMIZADO.sh

# Ejecutar
anuset-vtuber-desktop
```

#### **Windows**
```cmd
# 1. Descargar ZIP desde releases
# 2. Extraer y abrir PowerShell como Administrador
cd anuset-vtuber-desktop-optimized
.\INSTALAR-WINDOWS.bat

# 3. Buscar "AnuSet Desktop" en el menú Inicio
```

#### **macOS**
```bash
# Instalar Node.js primero
brew install node

# Luego instalar AnuSet
./INSTALAR-MACOS.sh
```

### **Opción 2: Instalación Manual**

```bash
# 1. Clonar repositorio
git clone https://github.com/tu-repo/anuset-desktop.git
cd anuset-vtuber-desktop-optimized

# 2. Instalar dependencias
npm install --legacy-peer-deps

# 3. Configurar API (opcional)
cp config/api-config.example.js config/api-config.js
# Editar config/api-config.js con tu API key

# 4. Ejecutar en desarrollo
npm run dev

# 5. O construir para producción
npm run build
npm run preview
```

## 🔑 Credenciales de Acceso

### **Usuario por Defecto**
- **Usuario**: `kali`
- **Contraseña**: `kali`

### **Primera Vez**
1. Ejecutar `anuset-vtuber-desktop`
2. La aplicación se abrirá automáticamente en http://localhost:3000
3. Usar las credenciales de arriba
4. ¡Listo para usar!

## 📱 Uso de la Aplicación

### **Navegación Principal**
- **Inicio**: Chat principal con avatar 3D
- **Dashboard**: Configuraciones y estadísticas
- **Configuración**: Ajustes de IA, TTS y avatar
- **Salir**: Cerrar aplicación

### **Funciones del Avatar**
- **Cargar VRM**: Arrastrar archivo .vrm a la ventana
- **Expresiones**: Usar controles faciales
- **Cámara**: Rotar, zoom y movimiento
- **Animaciones**: Reproducir expresiones predefinidas

### **Chat IA**
- **Escribir mensaje**: Campo de texto inferior
- **Enviar**: Enter o botón enviar
- **Historial**: Panel lateral con conversaciones
- **Personalidades**: Selector de estilos de respuesta

### **Configuraciones TTS**
- **Voz**: Seleccionar de las disponibles
- **Velocidad**: Ajustar palabras por minuto
- **Tono**: Modificar frecuencia de voz
- **Volumen**: Control de amplitud

## 🛠️ Configuración Avanzada

### **API Keys**
```javascript
// config/api-config.js
export const config = {
  gemini: {
    apiKey: 'tu-api-key-aqui', // Opcional, funciona sin API key
    model: 'gemini-pro'
  },
  tts: {
    provider: 'local', // 'local' o 'external'
    voice: 'es-ES-female'
  }
};
```

### **Personalización de Avatar**
```javascript
// Configurar avatar por defecto
const avatarConfig = {
  model: 'assets/avatar/default.vrm',
  expressions: {
    happy: 'expressions/happy.vrmjson',
    sad: 'expressions/sad.vrmjson'
  },
  lighting: {
    ambient: 0.5,
    directional: 0.8
  }
};
```

### **Variables de Entorno**
```bash
# .env
VITE_APP_NAME="AnuSet Desktop"
VITE_API_URL="http://localhost:3000"
VITE_ENABLE_LOGS="true"
VITE_TTS_ENGINE="local"
```

## 📁 Estructura del Proyecto

```
anuset-vtuber-desktop-optimized/
├── 📁 src/
│   ├── 📁 components/          # Componentes React
│   │   ├── ChatAvatar.jsx     # Avatar 3D con chat
│   │   ├── Dashboard.jsx      # Panel principal
│   │   ├── LoginForm.jsx      # Formulario de acceso
│   │   └── Settings.jsx       # Configuraciones
│   ├── 📁 contexts/           # Contextos de React
│   │   ├── AuthContext.jsx    # Autenticación
│   │   ├── AvatarContext.jsx  # Estado del avatar
│   │   └── ConfigContext.jsx  # Configuraciones
│   ├── 📁 utils/              # Utilidades
│   │   ├── database.js        # Base de datos SQLite
│   │   ├── geminiService.js   # Servicio IA
│   │   └── avatar3D.js        # Lógica 3D
│   └── App.jsx                # Componente principal
├── 📁 config/                 # Configuraciones
│   ├── api-config.js         # API keys y configuración
│   ├── database.sqlite       # Base de datos local
│   └── settings/             # Configuraciones JSON
├── 📁 assets/                # Recursos estáticos
│   ├── 📁 3d/               # Modelos VRM
│   ├── 📁 audio/            # Archivos de audio
│   ├── 📁 icons/            # Iconos de la aplicación
│   └── 📁 textures/         # Texturas 3D
├── INSTALAR-OPTIMIZADO.sh   # Script de instalación Linux
├── INSTALAR-WINDOWS.bat     # Script de instalación Windows
├── INSTALAR-MACOS.sh        # Script de instalación macOS
├── package.json             # Dependencias y scripts
├── vite.config.js           # Configuración de Vite
└── tailwind.config.js       # Configuración de Tailwind
```

## 🔧 Solución de Problemas

### **Problema: "Node.js no encontrado"**
```bash
# Arch Linux
sudo pacman -S nodejs npm

# Debian/Ubuntu
sudo apt update && sudo apt install nodejs npm

# macOS
brew install node

# Windows
# Descargar desde https://nodejs.org
```

### **Problema: "Error de dependencias npm"**
```bash
# Limpiar e instalar
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps

# O forzar instalación
npm install --force
```

### **Problema: "Avatar no carga"**
1. Verificar formato del archivo (.vrm)
2. Comprobar tamaño del archivo (< 50MB)
3. Revisar consola del navegador (F12)
4. Reiniciar aplicación

### **Problema: "Chat no responde"**
1. Verificar conexión a internet (opcional)
2. Comprobar API key en config/api-config.js
3. Reiniciar servicio IA
4. Verificar base de datos SQLite

### **Problema: "Puerto en uso"**
```bash
# Cambiar puerto por defecto
npm run dev -- --port 3001

# O matar proceso en puerto 3000
lsof -ti:3000 | xargs kill
```

### **Problema: "Audio no funciona"**
1. Verificar permisos de audio del navegador
2. Comprobar dispositivos de salida
3. Reiniciar audio del sistema
4. Verificar configuración TTS

## 🗑️ Desinstalación

### **Linux (Desinstalación Completa)**
```bash
# Parar servicio
sudo systemctl stop anuset-vtuber-desktop
sudo systemctl disable anuset-vtuber-desktop

# Eliminar archivos
sudo rm -rf /opt/anuset-vtuber-desktop
sudo rm /usr/local/bin/anuset-vtuber-desktop
sudo rm /usr/share/applications/anuset-vtuber-desktop.desktop
sudo rm /usr/share/pixmaps/anuset-vtuber-desktop.png
sudo rm /etc/systemd/system/anuset-vtuber-desktop.service

# Recargar systemd
sudo systemctl daemon-reload
```

### **Windows**
1. **Desinstalar desde Panel de Control**
   - Configuración → Aplicaciones
   - Buscar "AnuSet Desktop"
   - Clic en "Desinstalar"

2. **O eliminar manualmente**
   ```
   C:\Program Files\AnuSet Desktop\
   %AppData%\AnuSet Desktop\
   Desktop\AnuSet Desktop.lnk
   ```

### **macOS**
```bash
# Eliminar aplicación
rm -rf /Applications/AnuSet\ Desktop.app

# Eliminar datos de usuario
rm -rf ~/Library/Application\ Support/AnuSet\ Desktop
rm -rf ~/Library/Preferences/com.anuset.desktop.plist
```

## 📊 Rendimiento y Optimización

### **Configuración Recomendada**
- **RAM**: 8GB+ para mejor rendimiento
- **GPU**: Tarjeta dedicada para renderizado 3D
- **Almacenamiento**: SSD para carga rápida de assets

### **Optimizaciones Incluidas**
- **Lazy Loading**: Carga de componentes bajo demanda
- **Code Splitting**: División automática de código
- **Tree Shaking**: Eliminación de código no utilizado
- **Asset Optimization**: Compresión automática de recursos
- **Service Worker**: Cache offline para mejor rendimiento

### **Métricas de Rendimiento**
- **Tiempo de inicio**: < 3 segundos
- **Carga de avatar**: < 2 segundos
- **Respuesta de chat**: < 1 segundo
- **Uso de memoria**: < 200MB en idle

## 🤝 Contribución

### **Desarrollo Local**
```bash
# Clonar repositorio
git clone https://github.com/tu-repo/anuset-desktop.git
cd anuset-vtuber-desktop-optimized

# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm run dev

# Construir para producción
npm run build
```

### **Estructura de Commits**
- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Documentación
- `style:` Cambios de formato
- `refactor:` Refactorización de código
- `test:` Agregar tests
- `chore:` Mantenimiento

### **Pull Requests**
1. Fork del repositorio
2. Crear rama de feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit de cambios (`git commit -am 'feat: agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

**MIT License** - Ver archivo [LICENSE](LICENSE) para más detalles.

## 👥 Créditos

- **Desarrollo**: AnuSet Team
- **Tecnologías**: React, Vite, Three.js, SQLite, Gemini AI
- **UI/UX**: Tailwind CSS, Lucide Icons
- **3D**: @pixiv/three-vrm
- **IA**: Google Generative AI

## 📞 Soporte

### **Documentación**
- [Wiki del proyecto](https://github.com/tu-repo/anuset-desktop/wiki)
- [API Reference](https://github.com/tu-repo/anuset-desktop/docs/api.md)
- [Video Tutoriales](https://youtube.com/playlist?list=tu-playlist)

### **Comunidad**
- [Discord Server](https://discord.gg/anuset)
- [Telegram Group](https://t.me/anuset_community)
- [Reddit](https://reddit.com/r/anusetdesktop)

### **Issues y Bugs**
- [GitHub Issues](https://github.com/tu-repo/anuset-desktop/issues)
- [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md)
- [Feature Request](.github/ISSUE_TEMPLATE/feature_request.md)

### **Contacto**
- **Email**: support@anuset.dev
- **Twitter**: [@AnuSetDev](https://twitter.com/anusetdev)
- **Website**: https://anuset.dev

---

<div align="center">

### 🎭 ¡Disfruta creando contenido con AnuSet Desktop! ✨

**[⬆ Volver al inicio](#anuset-desktop-v421---aplicación-vtuber-ia-optimizada)**

</div>

---
*AnuSet Desktop v4.2.1 - Última actualización: 2025-11-10*