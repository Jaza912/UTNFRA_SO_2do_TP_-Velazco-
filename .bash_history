pwd
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
sudo apt update
sudo apt install wget gpg
UBUNTU_CODENAME=jammy
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt update && sudo apt install ansible
ansible --version
mkdir -p $HOME/RTA_Examen_$(date +%Y%m%d)
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
sudo pvcreate /dev/sdb /dev/sdc
sudo vgcreate vg_datos /dev/sdb
sudo vgcreate vg_temp  /dev/sdc
sudo lvcreate -n lv_docker -L 5M    vg_datos
sudo lvcreate -n lv_workareas -L 1.5G vg_datos
#!/bin/bash
TIMESTAMP=$(date +%Y%m%d)
mkdir $HOME/RTA_Examen_${TIMESTAMP}
touch $HOME/RTA_Examen_${TIMESTAMP}/Punto_A.sh
touch $HOME/RTA_Examen_${TIMESTAMP}/Punto_B.sh
touch $HOME/RTA_Examen_${TIMESTAMP}/Punto_C.sh
touch $HOME/RTA_Examen_${TIMESTAMP}/Punto_D.sh
# Habilita la opción para agregar nuevos comandos al final del historial de comandos.
shopt -s histappend
touch ~/.bash_history
chmod 600 ~/.bash_history
sudo chattr +a ~/.bash_history
# Agrega configuración al final del archivo .bashrc
cat << EOF >> ~/.bashrc
###########################################################
# Configuración del historial de comandos #
###########################################################
# Establece el tamaño máximo del historial en 10000 comandos.
export HISTSIZE=10000
# No hay límite en el tamaño del archivo de historial.
export HISTFILESIZE=-1
# Actualiza y sincroniza el historial de comandos entre sesiones.
export PROMPT_COMMAND="history -a; history -c; history -r; \$PROMPT_COMMAND"
EOF

# Recarga el archivo .bashrc para aplicar los cambios.
. ~/.bashrc
history -a
echo 
echo "Por favor ejecute: source  ~/.bashrc  && history -a "
echo 
ource ~/.bashrc
git clone https://github.com/upszot/UTN-FRA_SO_Examenes.git
sudo lvcreate -n lv_workareas -L 1.5G vg_datos
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
sudo pvs
sudo vgs
sudo lvs
swapon --show
sudo swapoff -v /dev/vg_temp/lv_swap || true
# Elimina lv_docker si existe
sudo lvremove -f /dev/vg_datos/lv_docker || true
# Elimina lv_swap si existe
sudo lvremove -f /dev/vg_temp/lv_swap || true
sudo vgremove -f vg_datos || true
sudo vgremove -f vg_temp  || true
# Esto borrará la metadata LVM en los dispositivos actuales
sudo pvremove -f /dev/sdb || true
sudo pvremove -f /dev/sdc || true
sudo pvs || true
sudo vgs || true
sudo lvs || true
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
# Crear PVs limpios
sudo pvcreate /dev/sdc
sudo pvcreate /dev/sdd
sudo vgcreate vg_datos /dev/sdc
sudo vgcreate vg_temp  /dev/sdd
# lv_docker 5M
sudo lvcreate -n lv_docker -L 5M    vg_datos
# lv_workareas 1.5G
sudo lvcreate -n lv_workareas -L 1.5G vg_datos
# lv_swap 512M
sudo lvcreate -n lv_swap   -L 512M  vg_temp
# Formatear
sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_workareas
# Crear puntos de montaje si no existen
sudo mkdir -p /var/lib/docker
sudo mkdir -p /work
# Montar (temporal)
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_workareas /work
# Preparar swap y activarla
sudo mkswap /dev/vg_temp/lv_swap
sudo swapon /dev/vg_temp/lv_swap
# Añadir líneas (reemplaza si ya existen entradas viejas)
echo "/dev/mapper/vg_datos-lv_docker   /var/lib/docker  ext4  defaults  0 2" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work            ext4  defaults  0 2" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_temp-lv_swap       none             swap  sw       0 0" | sudo tee -a /etc/fstab
# Probar montaje persistente
sudo mount -a
sudo pvs
sudo vgs
sudo lvs
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
df -h | egrep '/var/lib/docker|/work'
swapon --show
history -a
history | tail -n 80 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_A.sh
cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_A.sh
sudo tee /usr/local/bin/VelazcoAltaUser-Groups.sh > /dev/null <<'EOF'
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
EOF

sudo chmod +x /usr/local/bin/VelazcoAltaUser-Groups.sh
sudo /usr/local/bin/VelazcoAltaUser-Groups.sh vagrant $HOME/202406/bash_script/Lista_Usuarios.txt
sudo chmod +x /usr/local/bin/VelazcoAltaUser-Groups.sh
2Puser1,2Pgrupo1
2Puser2,2Pgrupo2
2Psupervisor,2PSupervisores
mkdir -p $HOME/202406/bash_script
nano $HOME/202406/bash_script/Lista_Usuarios.txt
/home/fabrizio/202406/bash_script/
Lista_Usuarios.txt
nano $HOME/202406/bash_script/Lista_Usuarios.txt
sudo /usr/local/bin/VelazcoAltaUser-Groups.sh vagrant $HOME/202406/bash_script/Lista_Usuarios.txt
history | tail -n 60 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh
cp /usr/local/bin/VelazcoAltaUser-Groups.sh $HOME/RTA_Examen_$(date +%Y%m%d)/
cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh
mkdir -p $HOME/202406/docker
cat > $HOME/202406/docker/Dockerfile <<'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF

cat > $HOME/202406/docker/index.html <<'EOF'
<html>
  <body>
    <h1>Fabrizio Velazco - División 116</h1>
  </body>
</html>
EOF

cat > $HOME/202406/docker/run.sh <<'EOF'
#!/bin/bash
docker run -d --rm -p 8080:80 --name web1-Velazco fabriziovelazco/web1-Velazco
EOF

chmod +x $HOME/202406/docker/run.sh
cd $HOME/202406/docker
docker login
docker build -t fabriziovelz/web1-velazco
cd ~/202406/docker
docker build -t fabriziovelz/web1-velazco .
sudo docker build -t fabriziovelz/web1-velazco .
sudo mkdir -p /var/lib/docker/tmp
sudo chown root:docker /var/lib/docker/tmp
sudo chmod 1777 /var/lib/docker/tmp
sudo docker build -t fabriziovelz/web1-velazco .
export DOCKER_BUILDKIT=0
sudo docker build -t fabriziovelz/web1-velazco .
ls -l
COPY html/index.html /usr/share/nginx/html/index.html
ls -l index.html
chmod 644 index.html
ls -l
export DOCKER_BUILDKIT=0
sudo docker build -t fabriziovelz/web1-velazco .
ls -l ~/202406/docker
sudo mkdir -p /var/lib/docker/buildkit/containerd-overlayfs/cachemounts
sudo chown -R root:docker /var/lib/docker/buildkit
sudo chmod -R 1777 /var/lib/docker/buildkit
export DOCKER_BUILDKIT=0
sudo docker build -t fabriziovelz/web1-velazco .
docker images
sudo docker images
sudo docker run -d -p 8080:80 fabriziovelz/web1-velazco
docker push fabriziovelz/web1-velazco
sudo docker push fabriziovelz/web1-velazco
docker whoami
docker login
sudo docker login
sudo docker push fabriziovelz/web1-velazco
history | tail -n 60 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_C.sh
cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_C.sh
roles/2do_parcial/
find $HOME/202406 -type d -name "roles"
mkdir -p $HOME/202406/ansible/roles/2do_parcial/{tasks,templates,vars}
cat > $HOME/202406/ansible/roles/2do_parcial/templates/datos_alumno.j2 <<'EOF'
Nombre: Fabrizio
Apellido: Velazco
Division: 116
EOF

cat > $HOME/202406/ansible/roles/2do_parcial/templates/datos_equipo.j2 <<'EOF'
IP: {{ ip }}
Distribucion: {{ distro }}
Cores: {{ cores }}
EOF

cat > $HOME/202406/ansible/roles/2do_parcial/vars/main.yml <<'EOF'
ip: 192.168.56.10
distro: ubuntu
cores: 2
EOF

cat > $HOME/202406/ansible/roles/2do_parcial/tasks/main.yml <<'EOF'
---
- name: Crear estructura
  file:
    path: "/tmp/2do_parcial/{{ item }}"
    state: directory
  loop:
    - alumno
    - equipo

- name: Crear archivo alumno
  template:
    src: datos_alumno.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt

- name: Crear archivo equipo
  template:
    src: datos_equipo.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt

- name: Sudoers 2PSupervisores
  lineinfile:
    path: /etc/sudoers
    regexp: '^%2PSupervisores'
    line: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
    validate: 'visudo -cf %s'
EOF

cat > $HOME/202406/ansible/site.yml <<'EOF'
- hosts: localhost
  become: yes
  roles:
    - 2do_parcial
EOF

cd $HOME/202406/ansible
ansible-playbook site.yml
history | tail -n 80 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_D.sh
cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_D.sh
ls -l
mkdir -p $HOME/UTNFRA_SO_2do_TP_-Velazco-
cd $HOME/UTNFRA_SO_2do_TP_-Velazco-
cp -r $HOME/202406 ./202406
cp -r $HOME/RTA_Examen_$(date +%Y%m%d) ./RTA_Examen_$(date +%Y%m%d)
history -a
