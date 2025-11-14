#!/bin/bash

ORIG_USER="$1"
LISTA="$2"

if [ -z "$ORIG_USER" ] || [ -z "$LISTA" ]; then
  echo "Uso: $0 <usuario_origen> <Path_Repo>/202406/bash_script/Lista_Usuarios.txt"
  exit 1
fi

if [ ! -f "$LISTA" ]; then
  echo "No existe $LISTA"
  exit 1
fi

HASH=$(sudo awk -F: -v u="$ORIG_USER" '($1==u){print $2}' /etc/shadow)
if [ -z "$HASH" ]; then
  echo "No pude obtener hash de ${ORIG_USER}"
  exit 1
fi

while IFS=, read -r username group; do
  username=$(echo "$username" | xargs)
  group=$(echo "$group" | xargs)
  [ -z "$group" ] && group="users"

  if ! getent group "$group" > /dev/null; then
    sudo groupadd "$group"
    echo "Grupo $group creado."
  fi

  if ! id "$username" &>/dev/null; then
    sudo useradd -m -G "$group" -s /bin/bash -p "$HASH" "$username"
    echo "Usuario $username creado y agregado a $group"
  else
    echo "Usuario $username ya existe."
    sudo usermod -a -G "$group" "$username"
  fi
done < "$LISTA"
