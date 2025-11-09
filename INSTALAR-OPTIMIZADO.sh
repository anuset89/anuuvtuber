#!/bin/bash
# ================================================================================
# INSTALADOR OPTIMIZADO - ANUSET DESKTOP v4.2.1
# Soporte: Arch Linux, Debian/Ubuntu, Windows
# Tecnología: React + Vite + Three.js + SQLite
# ================================================================================

set -euo pipefail

# Colores mejorados
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Configuración
APP_NAME="anuset-vtuber-desktop"
APP_VERSION="4.2.1"
INSTALL_DIR="/opt/$APP_NAME"
BIN_DIR="/usr/local/bin"
DESKTOP_FILE="/usr/share/applications/$APP_NAME.desktop"
ICON_DIR="/usr/share/pixmaps"

# Detectar sistema operativo
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &> /dev/null; then
            OS="arch"
        elif command -v apt &> /dev/null; then
            OS="debian"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        echo -e "${RED}[ERROR]${NC} Sistema operativo no soportado: $OSTYPE"
        exit 1
    fi
}

# Funciones de logging mejoradas
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_step() { echo -e "${CYAN}[STEP]${NC} $1"; }
log_banner() { echo -e "${BOLD}${MAGENTA}$1${NC}"; }

# Banner de inicio
show_banner() {
    clear
    echo -e "${BOLD}${MAGENTA}"
    echo "================================================================================"
    echo "     🎭 ANUSET DESKTOP v$APP_VERSION - INSTALADOR OPTIMIZADO"
    echo "     Aplicación VTuber IA con Avatar 3D"
    echo "     Tecnología: React + Vite + Three.js + SQLite"
    echo "================================================================================"
    echo -e "${NC}"
    echo -e "${BLUE}Sistema detectado: $OS${NC}"
    echo
}

# Verificar si se ejecuta como root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script debe ejecutarse como root (use sudo)"
        log_info "Comando: sudo $0"
        exit 1
    fi
}

# Verificar dependencias del sistema
check_dependencies() {
    log_info "Verificando dependencias del sistema..."
    
    if [[ "$OS" == "arch" ]]; then
        local deps=("nodejs" "npm" "python3")
        local install_cmd="pacman -S --noconfirm"
    elif [[ "$OS" == "debian" ]]; then
        log_info "Actualizando repositorios..."
        apt update || log_warning "Error actualizando repositorios"
        local deps=("nodejs" "npm" "python3" "curl" "wget")
        local install_cmd="apt install -y"
    else
        log_error "Sistema operativo no soportado para instalación automática"
        exit 1
    fi
    
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_info "Instalando dependencias faltantes: ${missing_deps[*]}"
        $install_cmd "${missing_deps[@]}"
    fi
    
    # Verificar versiones
    local node_ver=$(node -v 2>/dev/null || echo "no instalado")
    local npm_ver=$(npm -v 2>/dev/null || echo "no instalado")
    
    log_success "Dependencias verificadas"
    log_info "Node.js: $node_ver"
    log_info "NPM: $npm_ver"
    log_info "Python3: $(python3 --version 2>/dev/null || echo 'no instalado')"
}

# Crear directorio de instalación
setup_directories() {
    log_info "Configurando directorios de instalación..."
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$ICON_DIR"
    mkdir -p "/var/log/$APP_NAME"
    
    log_success "Directorios configurados"
}

# Instalar aplicación optimizada
install_app() {
    log_info "Instalando AnuSet Desktop v$APP_VERSION..."
    
    # Buscar directorio de aplicación
    local app_dir=""
    if [[ -d "./anuset-vtuber-desktop-optimized" ]]; then
        app_dir="./anuset-vtuber-desktop-optimized"
        log_info "Usando directorio: $app_dir"
    elif [[ -d "../anuset-vtuber-desktop-optimized" ]]; then
        app_dir="../anuset-vtuber-desktop-optimized"
        log_info "Usando directorio: $app_dir"
    else
        log_warning "Directorio de aplicación no encontrado, creando estructura básica"
        mkdir -p "$INSTALL_DIR"
    fi
    
    # Copiar archivos si existe el directorio
    if [[ -n "$app_dir" ]]; then
        log_info "Copiando archivos desde $app_dir..."
        cp -r "$app_dir"/* "$INSTALL_DIR/" 2>/dev/null || true
    fi
    
    # Crear script de lanzamiento optimizado
    cat > "$BIN_DIR/$APP_NAME" << 'EOF'
#!/bin/bash
# Script de lanzamiento de AnuSet Desktop
cd "/opt/anuset-vtuber-desktop"

if [[ ! -f "package.json" ]]; then
    echo "Error: package.json no encontrado"
    echo "Reinstale la aplicación"
    exit 1
fi

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "Error: Node.js no está instalado"
    echo "Instale con: sudo pacman -S nodejs npm (Arch) o sudo apt install nodejs npm (Debian)"
    exit 1
fi

# Instalar dependencias si es necesario
if [[ ! -d "node_modules" ]]; then
    echo "🔄 Instalando dependencias por primera vez..."
    echo "Esto puede tardar unos minutos..."
    npm install --legacy-peer-deps
elif [[ "package.json" -nt "node_modules" ]]; then
    echo "🔄 Actualizando dependencias..."
    npm install --legacy-peer-deps
fi

# Ejecutar aplicación
echo "🚀 Iniciando AnuSet Desktop..."
echo "📱 Abriendo en: http://localhost:3000"
echo "🔑 Credenciales: kali / kali"
echo "⏹️  Presione Ctrl+C para detener"
echo

npm run dev
EOF
    
    chmod +x "$BIN_DIR/$APP_NAME"
    
    # Instalar dependencias ahora si es la primera vez
    if [[ ! -d "$INSTALL_DIR/node_modules" ]] && [[ -f "$INSTALL_DIR/package.json" ]]; then
        log_info "Instalando dependencias de la aplicación..."
        cd "$INSTALL_DIR"
        npm install --legacy-peer-deps --silent
        log_success "Dependencias instaladas"
    fi
    
    log_success "Aplicación instalada"
}

# Crear icono optimizado
create_icon() {
    log_info "Creando icono de aplicación..."
    
    # Buscar icono en varios lugares
    local icon_source=""
    local possible_icons=(
        "./anuset-vtuber-desktop-optimized/assets/icons/app-icon.png"
        "./anuset-vtuber-desktop-optimized/assets/icons/app-icon.svg"
        "$INSTALL_DIR/assets/icons/app-icon.png"
        "$INSTALL_DIR/assets/icons/app-icon.svg"
    )
    
    for icon_path in "${possible_icons[@]}"; do
        if [[ -f "$icon_path" ]]; then
            icon_source="$icon_path"
            break
        fi
    done
    
    if [[ -n "$icon_source" ]]; then
        cp "$icon_source" "$ICON_DIR/$APP_NAME.png" 2>/dev/null || true
    else
        # Crear icono por defecto usando ImageMagick si está disponible
        if command -v convert &> /dev/null; then
            convert -size 256x256 xc:purple -fill white -gravity center -pointsize 72 -annotate +0+0 'A' "$ICON_DIR/$APP_NAME.png" 2>/dev/null || true
        fi
        # Si no hay ImageMagick, usar icono por defecto
        if [[ ! -f "$ICON_DIR/$APP_NAME.png" ]]; then
            echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==" | base64 -d > "$ICON_DIR/$APP_NAME.png"
        fi
    fi
    
    log_success "Icono creado"
}

# Crear archivo .desktop
create_desktop_file() {
    log_info "Creando entrada de escritorio..."
    
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=AnuSet Desktop
Comment=Aplicación VTuber IA con avatar 3D y chat inteligente
Exec=$APP_NAME
Icon=$APP_NAME
Terminal=false
Categories=AudioVideo;Audio;Network;Entertainment;
Keywords=vtuber;avatar;streaming;3d;ai;chat;
StartupWMClass=anuset-vtuber-desktop
StartupNotify=true
EOF
    
    log_success "Archivo .desktop creado"
}

# Crear servicio systemd (solo para Linux)
create_systemd_service() {
    if [[ "$OS" != "arch" && "$OS" != "debian" ]]; then
        return
    fi
    
    log_info "Creando servicio systemd..."
    
    cat > "/etc/systemd/system/$APP_NAME.service" << EOF
[Unit]
Description=AnuSet Desktop - Aplicación VTuber IA
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
ExecStart=$BIN_DIR/$APP_NAME
Restart=always
RestartSec=10
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/*/.Xauthority

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable "$APP_NAME.service"
    
    log_success "Servicio systemd creado y habilitado"
}

# Crear logs de instalación
create_install_log() {
    local log_file="/var/log/$APP_NAME/install.log"
    mkdir -p "$(dirname "$log_file")"
    
    cat > "$log_file" << EOF
Instalación de AnuSet Desktop v$APP_VERSION
============================================

Fecha: $(date)
Sistema: $OS
Usuario: $(whoami)
Directorio: $INSTALL_DIR
Versión Node.js: $(node -v 2>/dev/null || echo 'no instalado')
Versión NPM: $(npm -v 2>/dev/null || echo 'no instalado')

Archivos instalados:
- $BIN_DIR/$APP_NAME
- $DESKTOP_FILE
- $ICON_DIR/$APP_NAME.png

Credenciales por defecto:
Usuario: kali
Contraseña: kali

Para ejecutar: $APP_NAME
Para desinstalar: sudo rm -rf $INSTALL_DIR
Para deshabilitar servicio: sudo systemctl disable $APP_NAME.service
EOF
    
    log_success "Log de instalación creado: $log_file"
}

# Mostrar información final
show_completion_info() {
    echo
    echo -e "${BOLD}${GREEN}================================================================================"
    echo "     ✅ INSTALACIÓN COMPLETADA EXITOSAMENTE"
    echo "     AnuSet Desktop v$APP_VERSION - Optimizado"
    echo "================================================================================${NC}"
    echo
    
    echo -e "${CYAN}🚀 Para ejecutar AnuSet Desktop:${NC}"
    echo "  • Desde terminal: ${BOLD}$APP_NAME${NC}"
    echo "  • Desde menú: Buscar 'AnuSet Desktop' en aplicaciones"
    echo "  • URL local: http://localhost:3000"
    echo
    
    echo -e "${CYAN}🔑 Credenciales por defecto:${NC}"
    echo "  Usuario: ${BOLD}kali${NC}"
    echo "  Contraseña: ${BOLD}kali${NC}"
    echo
    
    echo -e "${CYAN}📁 Estructura de archivos:${NC}"
    echo "  • Aplicación: $INSTALL_DIR"
    echo "  • Comando: $BIN_DIR/$APP_NAME"
    echo "  • Entrada menú: $DESKTOP_FILE"
    echo "  • Icono: $ICON_DIR/$APP_NAME.png"
    echo "  • Logs: /var/log/$APP_NAME/"
    echo
    
    echo -e "${CYAN}🔧 Comandos útiles:${NC}"
    echo "  • Ver logs: sudo journalctl -u $APP_NAME.service -f"
    echo "  • Estado servicio: sudo systemctl status $APP_NAME.service"
    echo "  • Reiniciar: sudo systemctl restart $APP_NAME.service"
    echo "  • Parar servicio: sudo systemctl stop $APP_NAME.service"
    echo
    
    echo -e "${CYAN}🗑️ Para desinstalar:${NC}"
    echo "  sudo systemctl stop $APP_NAME.service"
    echo "  sudo systemctl disable $APP_NAME.service"
    echo "  sudo rm -rf $INSTALL_DIR"
    echo "  sudo rm $BIN_DIR/$APP_NAME"
    echo "  sudo rm $DESKTOP_FILE"
    echo "  sudo rm $ICON_DIR/$APP_NAME.png"
    echo "  sudo rm /etc/systemd/system/$APP_NAME.service"
    echo "  sudo systemctl daemon-reload"
    echo
    
    echo -e "${YELLOW}💡 Consejos:${NC}"
    echo "  • La aplicación funciona 100% offline"
    echo "  • Base de datos SQLite local incluida"
    echo "  • Avatar 3D con Three.js optimizado"
    echo "  • Chat IA con Gemini API integrada"
    echo
}

# Función principal
main() {
    # Detectar sistema operativo
    detect_os
    
    # Mostrar banner
    show_banner
    
    # Verificaciones
    check_root
    check_dependencies
    
    # Instalación
    log_step "Instalando AnuSet Desktop..."
    setup_directories
    install_app
    create_icon
    create_desktop_file
    create_systemd_service
    create_install_log
    
    # Información final
    show_completion_info
}

# Ejecutar instalación
main "$@"