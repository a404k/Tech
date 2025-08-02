#!/bin/bash

if ! command -v bash-obfuscate >/dev/null 2>&1; then
    echo "Error: bash-obfuscate no está instalado."
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Uso: $0 archivo.sh"
    exit 1
fi

f="$1"

if [ ! -f "$f" ]; then
    echo "El archivo '$f' no existe."
    exit 1
fi

tmp_ofs="$(mktemp)"
bash-obfuscate "$f" > "$tmp_ofs"

c=$(gzip -c "$tmp_ofs" | base64 | tr -d '\n')
rm "$tmp_ofs"

l=${#c}
max_len=$l

b=""
vars=()
i=0

generate_var_name() {
    echo "_$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 4)"
}

while [ "$i" -lt "$max_len" ]; do
    start=$((i + 1))
    end=$((i + 50))
    if [ "$end" -gt "$max_len" ]; then
        end=$max_len
    fi

    var_name=$(generate_var_name)
    frag=$(echo "$c" | cut -c${start}-${end})

    b="${b}${var_name}='$frag';"
    vars+=("$var_name")

    i=$((i + 50))
done

r="d='';"
for var in "${vars[@]}"; do
    r="${r}d=\$d\$$var;"
done

ofs="#!/system/bin/sh
${b}${r}echo \"\$d\" | base64 -d | gzip -d | sh
#Cannot decode
#Don't try to steal my code @404"

out="404.$(basename "$f")"
echo "$ofs" > "$out"
chmod +x "$out"

echo "✅ Script generado: $out"