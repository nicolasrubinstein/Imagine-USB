# imagineusb

Herramienta de terminal para **macOS y Linux** que, sobre `dd`, permite:

- **Levantar una imagen**: disco externo → archivo `.img`
- **Quemar una imagen**: archivo (`.img`, `.iso`, …) u otro disco → **uno o varios discos a la vez**

Es un único script en bash (compatible con el bash 3.2 de macOS), sin dependencias extra.

## Instalación

```bash
./install.sh          # copia el script a /usr/local/bin/imagineusb
sudo imagineusb
```

O sin instalar: `sudo ./imagineusb`. Si se ejecuta sin sudo, se relanza solo pidiendo la contraseña.

## Uso

```
sudo imagineusb          # asistente interactivo
sudo imagineusb --all    # incluye discos internos que no sean del sistema
```

Controles: `↑/↓` (o `j/k`) para moverse, `Enter` para elegir, `q`/`Esc` para volver.
En la selección de discos destino: `Espacio` marca, `a` marca todos, `r` vuelve a escanear.
Para las rutas hay autocompletado con `Tab`, y se puede arrastrar el archivo a la terminal.

## Cómo elige los discos

- **macOS**: `diskutil list` + `diskutil info`. Se muestran los discos físicos externos o
  removibles (lectores SD). Se excluye siempre el disco de arranque y su contenedor APFS.
- **Linux**: `lsblk` (más `fdisk -l` para mostrar la tabla de particiones). Se muestran discos
  removibles o conectados por USB/MMC. Se excluyen los que contienen `/`, `/boot`, `/home`,
  swap, etc. (también detrás de LVM/LUKS) y cualquier disco con particiones montadas fuera
  de `/media`, `/mnt` o `/run/media`.

## Seguridad

- Antes de quemar se muestran la tabla de particiones de cada destino y un resumen, y hay
  que escribir `QUEMAR` para confirmar.
- Si la imagen es más grande que el disco destino, la operación se cancela.
- Los discos se desmontan antes de copiar y al terminar se puede expulsarlos.
- `Ctrl+C` corta todos los `dd` en curso (el destino queda incompleto).

## Detalles técnicos

- En macOS se usa `/dev/rdiskN` (mucho más rápido) y el progreso se lee enviando `SIGINFO` a `dd`.
- En Linux se usa `dd bs=4M conv=fsync status=progress`.
- La copia a varios discos lanza un `dd` en paralelo por destino, con una barra de progreso para cada uno.
- La imagen levantada queda a nombre del usuario que ejecutó `sudo`, no de root.
- Las imágenes comprimidas (`.xz`, `.gz`, `.zip`…) hay que descomprimirlas antes.
