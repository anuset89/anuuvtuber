// Configuración de API y servicios para AnuSet Desktop
// Optimizado para funcionamiento offline-first

export const config = {
  // Configuración de la aplicación
  app: {
    name: 'AnuSet Desktop',
    version: '4.2.1',
    port: 3000,
    debug: false
  },

  // Configuración de Gemini AI
  gemini: {
    apiKey: 'AIzaSyDZLymhYz1uVPaSgTeWXJY2X_JsYsA7c7w', // Tu API key
    model: 'gemini-pro',
    temperature: 0.7,
    maxTokens: 2048,
    // Configuración offline (fallback)
    offlineMode: true,
    localResponses: {
      greeting: '¡Hola! Soy AnuSet, tu asistente VTuber IA. ¿En qué puedo ayudarte hoy?',
      goodbye: '¡Hasta luego! Fue un placer charlar contigo.',
      help: 'Puedo ayudarte con chat inteligente, configurar tu avatar 3D, o responder preguntas sobre streaming.'
    }
  },

  // Configuración de TTS (Text-to-Speech)
  tts: {
    provider: 'web', // 'web', 'external', 'offline'
    voices: [
      { id: 'es-ES-female-1', name: 'María (ES)', lang: 'es-ES', gender: 'female' },
      { id: 'es-ES-male-1', name: 'Carlos (ES)', lang: 'es-ES', gender: 'male' },
      { id: 'en-US-female-1', name: 'Emma (EN)', lang: 'en-US', gender: 'female' },
      { id: 'en-US-male-1', name: 'James (EN)', lang: 'en-US', gender: 'male' }
    ],
    defaultVoice: 'es-ES-female-1',
    speed: 1.0,
    pitch: 1.0,
    volume: 0.8
  },

  // Configuración de Avatar 3D
  avatar: {
    defaultModel: 'assets/3d/default.vrm',
    expressions: {
      happy: 'expressions/happy.vrmjson',
      sad: 'expressions/sad.vrmjson',
      surprised: 'expressions/surprised.vrmjson',
      angry: 'expressions/angry.vrmjson',
      thinking: 'expressions/thinking.vrmjson'
    },
    animations: {
      idle: 'animations/idle.fbx',
      talking: 'animations/talking.fbx',
      wave: 'animations/wave.fbx',
      nod: 'animations/nod.fbx'
    },
    lighting: {
      ambient: 0.6,
      directional: 0.8,
      shadows: true,
      environmentMap: 'assets/textures/studio.hdr'
    },
    camera: {
      distance: 2.0,
      minDistance: 1.0,
      maxDistance: 5.0,
      autoRotate: true,
      rotationSpeed: 0.5
    }
  },

  // Configuración de Base de Datos
  database: {
    type: 'sqlite',
    path: 'config/database.sqlite',
    tables: {
      users: 'users',
      conversations: 'conversations',
      settings: 'settings',
      avatar_configs: 'avatar_configs'
    },
    // Configuración offline
    backupEnabled: true,
    backupInterval: 24 * 60 * 60 * 1000, // 24 horas
    maxBackups: 7
  },

  // Configuración de Streaming
  streaming: {
    platforms: {
      twitch: {
        enabled: true,
        requiresAuth: false
      },
      youtube: {
        enabled: true,
        requiresAuth: false
      },
      discord: {
        enabled: true,
        requiresAuth: false
      }
    },
    overlay: {
      enabled: true,
      opacity: 0.8,
      position: 'bottom-right',
      maxMessages: 10
    }
  },

  // Personalidades de AnuSet
  personalities: {
    default: {
      name: 'AnuSet Normal',
      description: 'Personalidad equilibrada y amigable',
      tone: 'friendly',
      responseLength: 'medium',
      interests: ['tecnología', 'gaming', 'música', 'arte']
    },
    cute: {
      name: 'AnuSet Kawaii',
      description: 'Personalidad tierna y dulce',
      tone: 'cute',
      responseLength: 'short',
      interests: ['cute', 'anime', 'kawaii', 'bonito']
    },
    professional: {
      name: 'AnuSet Professional',
      description: 'Personalidad profesional y seria',
      tone: 'professional',
      responseLength: 'long',
      interests: ['negocios', 'tecnología', 'educación', 'profesional']
    },
    playful: {
      name: 'AnuSet Juguetona',
      description: 'Personalidad divertida y traviesa',
      tone: 'playful',
      responseLength: 'medium',
      interests: ['juegos', 'bromas', 'diversión', 'traviesa']
    },
    wise: {
      name: 'AnuSet Sabia',
      description: 'Personalidad reflexiva y sabia',
      tone: 'wise',
      responseLength: 'long',
      interests: ['filosofía', 'reflexión', 'sabiduría', 'conocimiento']
    }
  },

  // Configuración de UI
  ui: {
    theme: {
      primary: '#8B5CF6', // Purple
      secondary: '#06B6D4', // Cyan
      accent: '#F59E0B', // Amber
      background: 'linear-gradient(135deg, #1e293b 0%, #581c87 50%, #1e293b 100%)',
      text: '#f1f5f9'
    },
    animations: {
      enabled: true,
      duration: 300,
      easing: 'ease-in-out'
    },
    responsive: {
      breakpoints: {
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px'
      }
    }
  },

  // Configuración de Seguridad
  security: {
    sessionTimeout: 30 * 60 * 1000, // 30 minutos
    maxLoginAttempts: 5,
    requireAuth: false, // Para uso offline
    encryptLocalData: true,
    autoLogout: true
  },

  // Configuración de Logs
  logging: {
    level: 'info', // 'debug', 'info', 'warn', 'error'
    maxLogFiles: 5,
    maxLogSize: '10MB',
    enableConsole: true,
    enableFile: true
  },

  // Configuración de Updates
  updates: {
    checkInterval: 24 * 60 * 60 * 1000, // 24 horas
    autoUpdate: false,
    notifyUpdate: true,
    downloadOnBackground: true
  }
};

// Función para obtener configuración por entorno
export const getConfig = (section = null) => {
  if (section && config[section]) {
    return config[section];
  }
  return config;
};

// Función para validar configuración
export const validateConfig = () => {
  const required = ['gemini', 'tts', 'avatar', 'database', 'personalities'];
  const missing = required.filter(key => !config[key]);
  
  if (missing.length > 0) {
    console.warn(`Configuración faltante: ${missing.join(', ')}`);
    return false;
  }
  
  return true;
};

// Exportar configuración por defecto
export default config;