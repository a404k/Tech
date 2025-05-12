#!/data/data/com.termux/files/usr/bin/bash

# Autor: 404 (creador del script)
# Descripción: Instalación automática de Zsh personalizado para Termux

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
clear

echo -e "${CYAN}===========================================${NC}"
echo -e "${GREEN}     Instalador automático Zsh por 404${NC}"
echo -e "${CYAN}===========================================${NC}"
sleep 1

print_step() {
  echo -e "\n${CYAN}===========================================${NC}"
  echo -e "${GREEN}==> $1${NC}"
  echo -e "${CYAN}===========================================${NC}"
}

SCRIPT_DIR="${0%/*}"

print_step "Actualizando paquetes..."
sleep 1
yes|pkg update -y && yes|pkg upgrade -y && clear

print_step "Instalando dependencias..."
sleep 1
pkg install -y zsh git curl wget tsu python zoxide neofetch && clear

print_step "Configurando Zsh como shell predeterminado..."
chsh -s zsh

print_step "Instalando Oh My Zsh..."
sleep 1
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
clear

print_step "Instalando plugins de Zsh..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search
clear

print_step "Copiando fuente de letras (font.ttf)..."
sleep 1
mkdir -p ~/.termux
if [ -f "font.ttf" ]; then
  cp "font.ttf" ~/.termux/font.ttf
else
  echo -e "${RED}ERROR: No se encontró la fuente en /font.ttf${NC}"
  exit 1
fi

print_step "Desactivando mensaje de bienvenida..."
sleep 1
touch ~/.hushlogin

print_step "Agregando configuración de plugins y alias a .zshrc..."
ZSHRC_CONTENT=$(cat << 'EOF'

plugins=(
  git
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  extract
  alias-finder
)

eval "$(zoxide init zsh)"

alias update='pkg update && pkg upgrade -y'
alias e='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd'
alias ls='ls --color=auto'
alias ll='ls -la'
alias l='ls -lh'
alias c='clear'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias p='python'
alias py='python3'

source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
neofetch

EOF
)


if ! grep -q "alias update='pkg update" ~/.zshrc; then
  echo "$ZSHRC_CONTENT" >> ~/.zshrc
fi

print_step "Recargando Zsh..."
source ~/.zshrc
clear

echo -e "\n${YELLOW}Comandos rápidos que puedes usar ahora:${NC}"
echo -e "${CYAN}- update${NC}      → Actualiza todos los paquetes de Termux"
echo -e "${CYAN}- e${NC}           → Cierra el terminal"
echo -e "${CYAN}- .. / ...${NC}    → Sube una o dos carpetas"
echo -e "${CYAN}- home${NC}        → Va a tu carpeta principal"
echo -e "${CYAN}- ls / ll / l${NC} → Lista archivos (detallado, ocultos, legible)"
echo -e "${CYAN}- c${NC}           → Limpia la pantalla"
echo -e "${CYAN}- gs${NC}          → Ver el estado actual en Git"
echo -e "${CYAN}- ga${NC}          → Añadir todos los cambios"
echo -e "${CYAN}- gc${NC}          → Crear un commit"
echo -e "${CYAN}- gp${NC}          → Subir cambios a GitHub"
echo -e "${CYAN}- gl${NC}          → Ver historial de commits"
echo -e "${CYAN}- p / py${NC}      → Ejecutar Python 2 o 3"

echo -e "\n${GREEN}✔ Instalación completa. Script creado por 404.${NC}"
echo -e "${CYAN}Reinicia Termux para aplicar la fuente y usar tu nuevo entorno Zsh.${NC}"
