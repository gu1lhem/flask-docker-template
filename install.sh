#!/bin/bash

key_file="id_rsa"

# Install Docker and Nginx
apt update
sudo apt install docker.io docker-compose nginx -y

# Create usergroup for Docker to be executed without root
sudo usermod -a -G docker $USER
newgrp docker
#? Il faut peut-être se déconnecter puis reconnecter ici.

# Clés SSH pour GitHub
ssh-keygen
eval "$(ssh-agent -s)"
# Ne pas spécifier de mot de passe
cat .ssh/$key_file.pub
# Ajouter la clé à Github

echo "Host github.com" >> .ssh/config
echo "   IdentityFile ~/.ssh/"$key_file >> .ssh/config

ssh -T git@github.com

# Clonage
cd ~
git clone git@github.com:gu1lhem/flask-docker-test.git

cd flask-docker-test/

echo "Copie du ficher de configuration nginx..."
sudo cp ./flask-docker-test.conf /etc/nginx/conf.d/
sudo nginx -s reload

# Pour build :
# cd dans flask-docker-test puis :
#docker build -f Dockerfile -t react-flask-app-api .

# Pour run :
#docker run --rm -p 5000:5000 react-flask-app-api

# Avec docker-compose :
docker-compose up

# Pour installer un service systemd, lancer sudo chmod +x ./systemd.sh && sudo ./systemd.sh

# From :
# https://blog.miguelgrinberg.com/post/how-to-dockerize-a-react-flask-project
# https://www.toptal.com/flask/flask-production-recipes
# https://techoverflow.net/2020/10/24/create-a-systemd-service-for-your-docker-compose-project-in-10-seconds/
