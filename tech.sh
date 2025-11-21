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

cat >> ~/.zshrc << 'EOF'

neofetch

source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.oh-my-zsh/plugins/zsh-completions/zsh-completions.plugin.zsh

alias update='pkg update && pkg upgrade'
alias cls='clear'
alias ls='lsd'
alias cat='bat'

EOF

p "Copiando archivo AEF"

if [ -f "AEF" ]; then
    cp AEF /data/data/com.termux/files/usr/bin/AEF
    chmod +777 /data/data/com.termux/files/usr/bin/AEF
else
    echo -e "${R}ERROR: No se encontró el archivo AEF en esta carpeta.${NC}"
fi

p "Estableciendo ZSH como shell predeterminado..."

PASSWD="$PREFIX/etc/passwd"
USER=$(whoami)

if grep -q "^${USER}:" "$PASSWD"; then
    sed -i "s|:/data/data/com.termux/files/usr/bin/login|:/data/data/com.termux/files/usr/bin/zsh|" "$PASSWD"
fi

p "Limpiando historial..."
rm -rf ~/.bash_history

clear
echo -e "${G}"
echo -e "✔ Instalación completa.."
echo -e "Reinicia Termux para aplicar la fuente."
echo -e "Escribe ${Y}help${G} para ver los nuevos comandos."
echo -e "${NC}"

exec zsh
