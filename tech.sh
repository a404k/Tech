#!/bin/bash

R='\033[1;31m'
G='\033[1;32m'
C='\033[1;36m'
Y='\033[1;33m'
NC='\033[0m'

clear
echo -ne "${R}Iniciando:${NC} "
for i in $(seq 1 30); do
    echo -ne "${Y}.${NC}"
    sleep 0.1
done
echo -e " ${G}[OK]${NC}"

clear

p() {
    t="$1"
    echo -e "\n${C}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    echo -e "${C}┃  ➤ $t${NC}"
    echo -e "${C}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
}

p "Actualizando paquetes..."
yes | pkg update && yes | pkg upgrade

p "Instalando dependencias..."
yes | pkg install wget git python tsu zsh nano lsd bat nodejs neofetch

if ! command -v npm >/dev/null; then
    echo -e "${R}npm no está instalado. Algo falló.${NC}"
    exit 1
fi

p "Instalando paquetes npm..."
npm install -g bash-obfuscate

p "Instalando configuracion de Termux..."
mkdir -p ~/.termux

if [ -f "font.ttf" ]; then
    cp font.ttf ~/.termux/font.ttf
else
    echo -e "${R}ERROR: No se encontro la fuente font.ttf${NC}"
    exit 1
fi

p "Eliminando mensaje de Termux..."
rm -f $PREFIX/etc/motd

p "Configurando Neofetch..."
mkdir -p ~/.config/neofetch
[ -f "config.conf" ] && cp config.conf ~/.config/neofetch/config.conf
[ -f "ascii.txt" ] && cp ascii.txt ~/.config/neofetch/ascii.txt

p "Instalando Oh-My-Zsh..."
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

p "Instalando plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/plugins/zsh-completions

p "Modificando .zshrc..."

cat > ~/.zshrc << 'EOF'

plugins=(
  git
  zsh-completions
  zsh-history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
  extract
  sudo
)

neofetch

alias update='pkg update && pkg upgrade -y'
alias c='clear'
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -a'
alias cat='bat'
alias e='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pi='pkg install'
alias pu='pkg uninstall'
alias home='cd ~'
alias descargas='cd ~/storage/downloads'
alias sdcard='cd ~/storage/shared'
alias termux='cd /data/data/com.termux/files/home'
alias ts='termux-setup-storage'
alias wp='termux-wake-lock'
alias wpo='termux-wake-unlock'
alias ip='ip -c a'
alias myip='curl ifconfig.me'
alias help='echo -e "\n\033[1;36mAlias personales:\033[0m\n"; echo -e "\033[1;33mupdate\033[0m = pkg update && pkg upgrade -y"; echo -e "\033[1;33mc\033[0m = clear"; echo -e "\033[1;33mls\033[0m = lsd"; echo -e "\033[1;33mll\033[0m = lsd -l"; echo -e "\033[1;33mla\033[0m = lsd -a"; echo -e "\033[1;33mcat\033[0m = bat"; echo -e "\033[1;33me\033[0m = exit"; echo -e "\033[1;33m..\033[0m = cd .."; echo -e "\033[1;33m...\033[0m = cd ../.."; echo -e "\033[1;33m....\033[0m = cd ../../.."; echo -e "\033[1;33mpi\033[0m = pkg install"; echo -e "\033[1;33mpu\033[0m = pkg uninstall"; echo -e "\033[1;33mhome\033[0m = cd ~"; echo -e "\033[1;33mdescargas\033[0m = cd ~/storage/downloads"; echo -e "\033[1;33msdcard\033[0m = cd ~/storage/shared"; echo -e "\033[1;33mtermux\033[0m = cd /data/data/com.termux/files/home"; echo -e "\033[1;33mts\033[0m = termux-setup-storage"; echo -e "\033[1;33mwp\033[0m = termux-wake-lock"; echo -e "\033[1;33mwpo\033[0m = termux-wake-unlock"; echo -e "\033[1;33mip\033[0m = ip -c a"; echo -e "\033[1;33mmyip\033[0m = curl ifconfig.me"'

EOF

p "Copiando archivo AEF"

if [ -f "AEF" ]; then
    cp AEF /data/data/com.termux/files/usr/bin/AEF
    chmod +777 /data/data/com.termux/files/usr/bin/AEF
else
    echo -e "${R}ERROR: No se encontró el archivo AEF en esta carpeta.${NC}"
fi

p "Estableciendo shell predeterminado..."

chsh -s zsh

p "Limpiando historial..."
rm -rf ~/.bash_history

clear
echo -e "${G}"
echo -e "✔ Instalación completa.."
echo -e "Reinicia Termux para aplicar la fuente."
echo -e "Escribe ${Y}help${G} para ver los nuevos comandos."
echo -e "${NC}"

exec zsh
