#!/bin/bash

R='\033[1;31m'
G='\033[1;32m'
C='\033[1;36m'
Y='\033[1;33m'
NC='\033[0m'

clear
echo -ne "${R}Iniciando entorno:${NC} "
for i in $(seq 1 15); do
    echo -ne "${Y}.${NC}"
    sleep 0.05
done
echo -e " ${G}[OK]${NC}\n"

s() {
    m="$1"
    c="$2"
    echo -ne "${C}» $m... ${NC} "
    eval "$c" > /dev/null 2>&1 &
    p=$!
    sp='-\|/'
    i=0
    while kill -0 $p 2>/dev/null; do
        i=$(( (i + 1) % 4 ))
        printf "\b${sp:$i:1}"
        sleep 0.1
    done
    wait $p
    if [ $? -eq 0 ]; then
        echo -e "\b${G}[OK]${NC}"
    else
        echo -e "\b${R}[ERROR]${NC}"
    fi
}

s "Actualizando paquetes base" "yes | pkg update && yes | pkg upgrade"

if ! command -v git >/dev/null 2>&1; then
    s "Instalando git" "yes | pkg install git"
fi

s "Instalando dependencias" "yes | pkg install wget python tsu zsh nano lsd bat nodejs neofetch"

if ! command -v npm >/dev/null 2>&1; then
    echo -e "${R}npm no está instalado. Algo falló.${NC}"
    exit 1
fi

s "Configurando bash-obfuscate" "npm install -g bash-obfuscate"

if [ -f "font.ttf" ]; then
    s "Configurando Termux (Fuente)" "mkdir -p ~/.termux && cp font.ttf ~/.termux/font.ttf && rm -f $PREFIX/etc/motd"
else
    echo -e "${R}ERROR: No se encontró la fuente font.ttf${NC}"
    exit 1
fi

s "Integrando Neofetch" "mkdir -p ~/.config/neofetch && [ -f 'config.conf' ] && cp config.conf ~/.config/neofetch/config.conf; [ -f 'ascii.txt' ] && cp ascii.txt ~/.config/neofetch/ascii.txt"

s "Instalando Oh-My-Zsh" "rm -rf ~/.oh-my-zsh && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"

s "Añadiendo plugins de Zsh" "git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/plugins/zsh-syntax-highlighting && git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/plugins/zsh-history-substring-search && git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/plugins/zsh-completions"

echo -ne "${C}» Escribiendo configuraciones en .zshrc... ${NC}"
cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-completions
  zsh-history-substring-search
  extract
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
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
echo -e "${G}[OK]${NC}"

if [ -f "AEF" ]; then
    s "Registrando ejecutable AEF" "cp AEF /data/data/com.termux/files/usr/bin/AEF && chmod +777 /data/data/com.termux/files/usr/bin/AEF"
else
    echo -e "${R}ERROR: No se encontró el archivo AEF en esta carpeta.${NC}"
fi

s "Estableciendo Zsh como default" "chsh -s zsh"
s "Limpiando archivos temporales" "rm -rf ~/.bash_history"

echo -e "\n${G}✔ ¡Instalación completada con éxito!${NC}"
echo -e "Escribe ${Y}help${NC} para ver los comandos rápidos que agregamos.\n"

exec zsh
