#!/bin/sh

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

l=$(echo -n "$c" | wc -c)
max_len=$l

b=""
i=0
while [ "$i" -lt "$max_len" ]; do
    start=$((i+1))
    end=$((i+50))
    if [ "$end" -gt "$max_len" ]; then
        end=$max_len
    fi
    frag=$(echo "$c" | cut -c${start}-${end})
    b="${b}p$i='$frag';"
    i=$((i+50))
done

r="d='';"
i=0
while [ "$i" -lt "$max_len" ]; do
    r="${r}d=\$d\$p$i;"
    i=$((i+50))
done

ofs="#!/system/bin/sh
${b}${r}echo \"\$d\" | base64 -d | gzip -d | sh

#Cannot decode
#Don't try to steal my code @404"

out="404.$(basename "$f")"
echo "$ofs" > "$out"
chmod +x "$out"

echo "✅ Script super ofuscado generado: $out"