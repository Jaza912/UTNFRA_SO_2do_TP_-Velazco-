  164  nano $HOME/202406/bash_script/Lista_Usuarios.txt
  165  /home/fabrizio/202406/bash_script/
  166  Lista_Usuarios.txt
  167  nano $HOME/202406/bash_script/Lista_Usuarios.txt
  168  sudo /usr/local/bin/VelazcoAltaUser-Groups.sh vagrant $HOME/202406/bash_script/Lista_Usuarios.txt
  169  history | tail -n 60 > $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh
  170  cp /usr/local/bin/VelazcoAltaUser-Groups.sh $HOME/RTA_Examen_$(date +%Y%m%d)/
  171  cat $HOME/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh
  172  mkdir -p $HOME/202406/docker
  173  cat > $HOME/202406/docker/Dockerfile <<'EOF'
  174  FROM nginx:alpine
  175  COPY index.html /usr/share/nginx/html/index.html
  176  EOF
  177  cat > $HOME/202406/docker/index.html <<'EOF'
  178  <html>
  179    <body>
  180      <h1>Fabrizio Velazco - División 116</h1>
  181    </body>
  182  </html>
  183  EOF
  184  cat > $HOME/202406/docker/run.sh <<'EOF'
  185  #!/bin/bash
  186  docker run -d --rm -p 8080:80 --name web1-Velazco fabriziovelazco/web1-Velazco
  187  EOF
  188  chmod +x $HOME/202406/docker/run.sh
  189  cd $HOME/202406/docker
  190  docker login
  191  docker build -t fabriziovelz/web1-velazco
  192  cd ~/202406/docker
  193  docker build -t fabriziovelz/web1-velazco .
  194  sudo docker build -t fabriziovelz/web1-velazco .
  195  sudo mkdir -p /var/lib/docker/tmp
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
