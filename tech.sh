#!/data/data/com.termux/files/usr/bin/bash

R='\033[1;31m'
G='\033[1;32m'
C='\033[1;36m'
Y='\033[1;33m'
NC='\033[0m'
clear

echo -ne "${C}Iniciando: "
for i in $(seq 1 30);do echo -ne ".";sleep 0.1;done
echo -e "${G} [OK]${NC}"
clear

echo -e "${C}===========================================${NC}"
echo -e "${G}      Personalizacion Termux por 404${NC}"
echo -e "${C}===========================================${NC}"
sleep 1

p() { echo -e "\n${C}===========================================${NC}"; echo -e "${G}==> $1${NC}"; echo -e "${C}===========================================${NC}"; }

SPATH="$(realpath "$0")"
SDIR="$(dirname "$SPATH")"
cd "$SDIR" || { echo -e "${R}Error: No se pudo cambiar al directorio del script.${NC}"; exit 1; }

p "Actualizando paquetes..."
sleep 1
yes|pkg update -y && yes|pkg upgrade -y && clear

p "Instalando dependencias..."
sleep 1
pkg install -y zsh git curl wget tsu python zoxide neofetch lsd bat nodejs && npm install -g bash-obfuscate && clear

p "Configurando Zsh como shell predeterminado..."
chsh -s zsh

p "Instalando Oh My Zsh..."
sleep 1
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
clear

p "Instalando plugins de Zsh..."
ZC="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZC/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZC/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search $ZC/plugins/zsh-history-substring-search
clear

p "Copiando fuente de letras (font.ttf)..."
sleep 1
mkdir -p ~/.termux
if [ -f "$SDIR/font.ttf" ];then cp "$SDIR/font.ttf" ~/.termux/font.ttf;else echo -e "${R}ERROR: No se encontró la fuente font.ttf${NC}";exit 1;fi

p "Copiando configuración de neofetch (config.conf)..."
mkdir -p ~/.config/neofetch
if [ -f "$SDIR/config.conf" ];then cp "$SDIR/config.conf" ~/.config/neofetch/config.conf; cp "$SDIR/ascii.txt" ~/.config/neofetch/ascii.txt;else echo -e "${R}ERROR: No se encontró config.conf${NC}";exit 1;fi

p "Desactivando mensaje de bienvenida..."
sleep 1
touch ~/.hushlogin

p "Agregando configuración de plugins y alias a .zshrc..."
ZSHRC=$(cat << 'EOF'
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
alias ofuscar='bash-obfuscate'
alias e='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias ls='lsd'
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
alias help='echo -e "\n${C}Comandos rápidos:${NC}\n\n${C}- update${NC} ➤ Actualiza todos los paquetes de Termux\n${C}- e${NC} ➤ Cierra el terminal\n${C}- .. / ...${NC} ➤ Sube una o dos carpetas\n${C}- home${NC} ➤ Va a tu carpeta principal\n${C}- ls / ll / l${NC} ➤ Lista archivos (detallado, ocultos, legible)\n${C}- c${NC} ➤ Limpia la pantalla\n${C}- gs${NC} ➤ Ver el estado actual en Git\n${C}- ga${NC} ➤ Añadir todos los cambios\n${C}- gc${NC} ➤ Crear un commit\n${C}- gp${NC} ➤ Subir cambios a GitHub\n${C}- gl${NC} ➤ Ver historial de commits\n${C}- p / py${NC} ➤ Ejecutar Python 2 o 3"'

source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
neofetch
EOF
)

if ! grep -q "alias update='pkg update" ~/.zshrc; then echo "$ZSHRC" >> ~/.zshrc;fi

p "Recargando Zsh..."
source ~/.zshrc
clear

echo -e "\n${G}✔ Instalación completa. Script creado por 404.${NC}"
echo -e "${C}Reinicia Termux para aplicar la fuente si es necesario.${NC}"
echo -e "${Y}Escribe ${C}\033[1mhelp\033[0m${Y} en la terminal para ver los comandos nuevos.${NC}"

exec zsh
