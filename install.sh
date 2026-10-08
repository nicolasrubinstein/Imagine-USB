#!/usr/bin/env bash
# Instala imagineusb en /usr/local/bin (o en el prefijo que se pase: ./install.sh /opt/bin)
set -e
DEST="${1:-/usr/local/bin}"
SRC="$(cd "$(dirname "$0")" && pwd)/imagineusb"
if [ "$(id -u)" -ne 0 ]; then
  echo "Instalando en $DEST (se necesita sudo)…"
  exec sudo "$BASH" "$0" "$@"
fi
mkdir -p "$DEST"
install -m 755 "$SRC" "$DEST/imagineusb"
echo "✔ Instalado: $DEST/imagineusb"
echo "  Ejecutalo con:  sudo imagineusb"
