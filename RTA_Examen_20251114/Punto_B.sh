  110  echo "/dev/mapper/vg_datos-lv_workareas /work            ext4  defaults  0 2" | sudo tee -a /etc/fstab
  111  echo "/dev/mapper/vg_temp-lv_swap       none             swap  sw       0 0" | sudo tee -a /etc/fstab
  112  # Probar montaje persistente
  113  sudo mount -a
  114  sudo pvs
  115  sudo vgs
  116  sudo lvs
  117  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
  118  df -h | egrep '/var/lib/docker|/work'
  119  swapon --show
  120  history -a
  121  history | tail -n 80 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_A.sh
  122  cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_A.sh
  123  sudo tee /usr/local/bin/VelazcoAltaUser-Groups.sh > /dev/null <<'EOF'
  124  #!/bin/bash
  125  ORIG_USER="$1"
  126  LISTA="$2"
  127  if [ -z "$ORIG_USER" ] || [ -z "$LISTA" ]; then
  128    echo "Uso: $0 <usuario_origen> <Path_Repo>/202406/bash_script/Lista_Usuarios.txt"
  129    exit 1
  130  fi
  131  if [ ! -f "$LISTA" ]; then
  132    echo "No existe $LISTA"
  133    exit 1
  134  fi
  135  HASH=$(sudo awk -F: -v u="$ORIG_USER" '($1==u){print $2}' /etc/shadow)
  136  if [ -z "$HASH" ]; then
  137    echo "No pude obtener hash de ${ORIG_USER}"
  138    exit 1
  139  fi
  140  while IFS=, read -r username group; do
  141    username=$(echo "$username" | xargs)
  142    group=$(echo "$group" | xargs)
  143    [ -z "$group" ] && group="users"
  144    if ! getent group "$group" > /dev/null; then
  145      sudo groupadd "$group"
  146      echo "Grupo $group creado."
  147    fi
  148    if ! id "$username" &>/dev/null; then
  149      sudo useradd -m -G "$group" -s /bin/bash -p "$HASH" "$username"
  150      echo "Usuario $username creado y agregado a $group"
  151    else
  152      echo "Usuario $username ya existe."
  153      sudo usermod -a -G "$group" "$username"
  154    fi
  155  done < "$LISTA"
  156  EOF
  157  sudo chmod +x /usr/local/bin/VelazcoAltaUser-Groups.sh
  158  sudo /usr/local/bin/VelazcoAltaUser-Groups.sh vagrant $HOME/202406/bash_script/Lista_Usuarios.txt
  159  sudo chmod +x /usr/local/bin/VelazcoAltaUser-Groups.sh
  160  2Puser1,2Pgrupo1
  161  2Puser2,2Pgrupo2
  162  2Psupervisor,2PSupervisores
  163  mkdir -p $HOME/202406/bash_script
  164  nano $HOME/202406/bash_script/Lista_Usuarios.txt
  165  /home/fabrizio/202406/bash_script/
  166  Lista_Usuarios.txt
  167  nano $HOME/202406/bash_script/Lista_Usuarios.txt
  168  sudo /usr/local/bin/VelazcoAltaUser-Groups.sh vagrant $HOME/202406/bash_script/Lista_Usuarios.txt
  169  history | tail -n 60 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh
