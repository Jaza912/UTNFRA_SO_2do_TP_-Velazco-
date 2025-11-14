   42  touch ~/.bash_history
   43  chmod 600 ~/.bash_history
   44  sudo chattr +a ~/.bash_history
   45  # Agrega configuración al final del archivo .bashrc
   46  cat << EOF >> ~/.bashrc
   47  ###########################################################
   48  # Configuración del historial de comandos #
   49  ###########################################################
   50  # Establece el tamaño máximo del historial en 10000 comandos.
   51  export HISTSIZE=10000
   52  # No hay límite en el tamaño del archivo de historial.
   53  export HISTFILESIZE=-1
   54  # Actualiza y sincroniza el historial de comandos entre sesiones.
   55  export PROMPT_COMMAND="history -a; history -c; history -r; \$PROMPT_COMMAND"
   56  EOF
   57  # Recarga el archivo .bashrc para aplicar los cambios.
   58  . ~/.bashrc
   59  history -a
   60  echo 
   61  echo "Por favor ejecute: source  ~/.bashrc  && history -a "
   62  echo 
   63  ource ~/.bashrc
   64  git clone https://github.com/upszot/UTN-FRA_SO_Examenes.git
   65  sudo lvcreate -n lv_workareas -L 1.5G vg_datos
   66  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   67  sudo pvs
   68  sudo vgs
   69  sudo lvs
   70  swapon --show
   71  sudo swapoff -v /dev/vg_temp/lv_swap || true
   72  # Elimina lv_docker si existe
   73  sudo lvremove -f /dev/vg_datos/lv_docker || true
   74  # Elimina lv_swap si existe
   75  sudo lvremove -f /dev/vg_temp/lv_swap || true
   76  sudo vgremove -f vg_datos || true
   77  sudo vgremove -f vg_temp  || true
   78  # Esto borrará la metadata LVM en los dispositivos actuales
   79  sudo pvremove -f /dev/sdb || true
   80  sudo pvremove -f /dev/sdc || true
   81  sudo pvs || true
   82  sudo vgs || true
   83  sudo lvs || true
   84  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   85  # Crear PVs limpios
   86  sudo pvcreate /dev/sdc
   87  sudo pvcreate /dev/sdd
   88  sudo vgcreate vg_datos /dev/sdc
   89  sudo vgcreate vg_temp  /dev/sdd
   90  # lv_docker 5M
   91  sudo lvcreate -n lv_docker -L 5M    vg_datos
   92  # lv_workareas 1.5G
   93  sudo lvcreate -n lv_workareas -L 1.5G vg_datos
   94  # lv_swap 512M
   95  sudo lvcreate -n lv_swap   -L 512M  vg_temp
   96  # Formatear
   97  sudo mkfs.ext4 /dev/vg_datos/lv_docker
   98  sudo mkfs.ext4 /dev/vg_datos/lv_workareas
   99  # Crear puntos de montaje si no existen
  100  sudo mkdir -p /var/lib/docker
  101  sudo mkdir -p /work
  102  # Montar (temporal)
  103  sudo mount /dev/vg_datos/lv_docker /var/lib/docker
  104  sudo mount /dev/vg_datos/lv_workareas /work
  105  # Preparar swap y activarla
  106  sudo mkswap /dev/vg_temp/lv_swap
  107  sudo swapon /dev/vg_temp/lv_swap
  108  # Añadir líneas (reemplaza si ya existen entradas viejas)
  109  echo "/dev/mapper/vg_datos-lv_docker   /var/lib/docker  ext4  defaults  0 2" | sudo tee -a /etc/fstab
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
