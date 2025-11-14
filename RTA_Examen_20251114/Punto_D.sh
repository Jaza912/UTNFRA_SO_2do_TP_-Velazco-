  196  sudo chown root:docker /var/lib/docker/tmp
  197  sudo chmod 1777 /var/lib/docker/tmp
  198  sudo docker build -t fabriziovelz/web1-velazco .
  199  export DOCKER_BUILDKIT=0
  200  sudo docker build -t fabriziovelz/web1-velazco .
  201  ls -l
  202  COPY html/index.html /usr/share/nginx/html/index.html
  203  ls -l index.html
  204  chmod 644 index.html
  205  ls -l
  206  export DOCKER_BUILDKIT=0
  207  sudo docker build -t fabriziovelz/web1-velazco .
  208  ls -l ~/202406/docker
  209  sudo mkdir -p /var/lib/docker/buildkit/containerd-overlayfs/cachemounts
  210  sudo chown -R root:docker /var/lib/docker/buildkit
  211  sudo chmod -R 1777 /var/lib/docker/buildkit
  212  export DOCKER_BUILDKIT=0
  213  sudo docker build -t fabriziovelz/web1-velazco .
  214  docker images
  215  sudo docker images
  216  sudo docker run -d -p 8080:80 fabriziovelz/web1-velazco
  217  docker push fabriziovelz/web1-velazco
  218  sudo docker push fabriziovelz/web1-velazco
  219  docker whoami
  220  docker login
  221  sudo docker login
  222  sudo docker push fabriziovelz/web1-velazco
  223  history | tail -n 60 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_C.sh
  224  cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_C.sh
  225  roles/2do_parcial/
  226  find $HOME/202406 -type d -name "roles"
  227  mkdir -p $HOME/202406/ansible/roles/2do_parcial/{tasks,templates,vars}
  228  cat > $HOME/202406/ansible/roles/2do_parcial/templates/datos_alumno.j2 <<'EOF'
  229  Nombre: Fabrizio
  230  Apellido: Velazco
  231  Division: 116
  232  EOF
  233  cat > $HOME/202406/ansible/roles/2do_parcial/templates/datos_equipo.j2 <<'EOF'
  234  IP: {{ ip }}
  235  Distribucion: {{ distro }}
  236  Cores: {{ cores }}
  237  EOF
  238  cat > $HOME/202406/ansible/roles/2do_parcial/vars/main.yml <<'EOF'
  239  ip: 192.168.56.10
  240  distro: ubuntu
  241  cores: 2
  242  EOF
  243  cat > $HOME/202406/ansible/roles/2do_parcial/tasks/main.yml <<'EOF'
  244  ---
  245  - name: Crear estructura
  246    file:
  247      path: "/tmp/2do_parcial/{{ item }}"
  248      state: directory
  249    loop:
  250      - alumno
  251      - equipo
  252  - name: Crear archivo alumno
  253    template:
  254      src: datos_alumno.j2
  255      dest: /tmp/2do_parcial/alumno/datos_alumno.txt
  256  - name: Crear archivo equipo
  257    template:
  258      src: datos_equipo.j2
  259      dest: /tmp/2do_parcial/equipo/datos_equipo.txt
  260  - name: Sudoers 2PSupervisores
  261    lineinfile:
  262      path: /etc/sudoers
  263      regexp: '^%2PSupervisores'
  264      line: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
  265      validate: 'visudo -cf %s'
  266  EOF
  267  cat > $HOME/202406/ansible/site.yml <<'EOF'
  268  - hosts: localhost
  269    become: yes
  270    roles:
  271      - 2do_parcial
  272  EOF
  273  cd $HOME/202406/ansible
  274  ansible-playbook site.yml
  275  history | tail -n 80 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_D.sh
