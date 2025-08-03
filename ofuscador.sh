#!/data/data/com.termux/files/usr/bin/sh

_cM="\033[35m"
_cP="\033[95m"
_cW="\033[97m"
_cY="\033[33m"
_cR="\033[31m"
_cG="\033[32m"
_c0="\033[0m"

echo "${_cP}📦 Intentando instalar dependencias...${_c0}"
echo "${_cP}• Instalando shc...${_c0}"
apt install -y shc >/dev/null 2>&1
echo "${_cP}• Instalando binutils...${_c0}"
pkg install -y binutils >/dev/null 2>&1
echo "${_cP}• Instalando openssl...${_c0}"
pkg install -y openssl >/dev/null 2>&1
echo "${_cP}• Instalando coreutils...${_c0}"
pkg install -y coreutils >/dev/null 2>&1
echo "${_cP}• Instalando clang...${_c0}"
pkg install -y clang >/dev/null 2>&1

_a_r() {
  _r="\033[31m"
  _x="\033[0m"
  l1="a 4 5 c d Y 5 6 g i j 3 6 K L O P Q R S 7 8 9 5 6 g 3 K 9"
  l2="A B C D E F G H I J K L M N O P Q R S T U V 6  5  7 g i S 9"
  l3="a b c d e f g h i j k l m n o p q r s t u y z 5 6 g 3 L 9"
  l4="a 4 5 c d 5 6 g i j 3 6 K L O P Q R S 7 8 9 Y 5 6 g i 8 9"

  _f() {
    for c in $(echo "$1" | tr ' ' '\n' | shuf); do
      printf "${_r}%s ${_x}" "$c"
    done
    echo
  }

  local start=$(date +%s)
  local now=$start
  local time=4
  while [ $(( now - start )) -lt $time ]; do
    clear
    _f "$l1"
    _f "$l2"
    _f "$l3"
    _f "$l4"
    _f "$l1"
    _f "$l1"
    _f "$l1"
    _f "$l1"
    _f "$l1"
    _f "$l1"
    _f "$l1"
    _f "$l1"
    sleep 0.2
    now=$(date +%s)
  done
}

_e="echo"
_obf="bash-obfuscate"
_b64="base64"

clear
$_e "${_cM}╔══════════════════════════════════════════════════════════╗${_c0}"
$_e "${_cP}║                   🔐  OFUSCADOR DE BASH                  ║${_c0}"
$_e "${_cM}╠══════════════════════════════════════════════════════════╣${_c0}"
$_e "${_cM}║  1)${_cW} 🔁  Nivel 1  -  Una pasada                           ${_cM}║${_c0}"
$_e "${_cM}║  2)${_cW} 🔁  Nivel 2  -  Dos pasadas                          ${_cM}║${_c0}"
$_e "${_cM}║  3)${_cW} 🔁  Nivel 3  -  Doble + Base64                       ${_cM}║${_c0}"
$_e "${_cM}║  4)${_cW} 🛠️  Nivel 4  -  Compilar con SHC                      ${_cM}║${_c0}"
$_e "${_cM}║  5)${_cW} 🔐  Nivel 5  -  Cifrar / Descifrar (AES)             ${_cM}║${_c0}"
$_e "${_cM}║  0)${_cR} ❌  Salir                                            ${_cM}║${_c0}"
$_e "${_cM}╚══════════════════════════════════════════════════════════╝${_c0}"
$_e ""

read -p "📌 Elige una opción: " _opt

d_ph="/sdcard"
read -p "📂 Nombre del archivo (.sh): " _file
_f="$d_ph/${_file}.sh"

if [ ! -f "$_f" ]; then
  $_e "${_cR}❗ Error: El archivo '$_f' no existe.${_c0}"
  $_e "${_cY}📌 Verifica que esté en /sdcard.${_c0}"
  exit 1
fi

case $_opt in
  1)
    _out="${_f}.ofus"
    $_obf "$_f" > "$_out"
    _a_r 
    $_e "${_cG}✅ Nivel 1 listo: '$_out'${_c0}"
    ;;
  2)
    _out="${_f}.ofus2"
    _t1=$(mktemp)
    $_obf "$_f" > "$_t1"
    $_obf "$_t1" > "$_out"
    rm "$_t1"
    _a_r
    $_e "${_cG}✅ Nivel 2 listo: '$_out'${_c0}"
    ;;
  3)
    _out="${_f}.ofus3"
    _t1=$(mktemp)
    _t2=$(mktemp)
    $_obf "$_f" > "$_t1"
    $_obf "$_t1" > "$_t2"
    $_b64 "$_t2" > "$_out"
    rm "$_t1" "$_t2"
    _a_r
    $_e "${_cG}✅ Nivel 3 listo: '$_out'${_c0}"
    ;;
  4)
    _out="${_f%.sh}.x"
    shc -f "$_f" -o "$_out"
    _a_r
    $_e "${_cG}✅ Nivel 4 (SHC) listo: '$_out'${_c0}"
    ;;
  5)
    $_e ""
    $_e "${_cW}🔐 ¿Qué deseas hacer?${_c0}"
    $_e "${_cM}[1] Cifrar script"
    $_e "${_cM}[2] Descifrar archivo .enc"
    read -p "👉 Elige una opción: " _subopt

    case $_subopt in
      1)
        _out="${_f}.enc"
        read -sp "🔑 Contraseña para cifrar: " _pw
        $_obf "$_f" | openssl enc -aes-256-cbc -salt -out "$_out" -pass pass:"$_pw"
        _a_r
        $_e "${_cG}✅ Script cifrado y guardado como: '${_out}'${_c0}"
        ;;
      2)
        read -p "📄 Nombre del archivo .enc (sin ruta): " _encname
        _in="$d_ph/$_encname"
        if [[ ! -f "$_in" ]]; then
          $_e "${_cR}❗ Archivo no encontrado: $_in${_c0}"
          exit 1
        fi
        read -sp "🔑 Contraseña para descifrar: " _pw
        _out_dec="${_in%.enc}.dec.sh"
        openssl enc -d -aes-256-cbc -in "$_in" -out "$_out_dec" -pass pass:"$_pw" 2>/dev/null

        if [[ $? -ne 0 ]]; then
          $_e ""
          $_e "${_cR}❌ Error: Contraseña incorrecta o archivo dañado.${_c0}"
          exit 1
        fi

        chmod +x "$_out_dec"
        clear
        $_e "${_cG}✅ Script descifrado: '$_out_dec'${_c0}"
        ;;
      *)
        $_e "${_cR}❌ Opción inválida para nivel 5.${_c0}"
        ;;
    esac
    ;;
  0)
    $_e "${_cY}👋 Saliendo...${_c0}"
    exit 0
    ;;
  *)
    $_e "${_cR}❌ Opción inválida.${_c0}"
    ;;
esac