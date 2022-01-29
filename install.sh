#!/bin/bash

key_file="id_rsa"

# Install Docker and Nginx
apt update
sudo apt install docker.io nginx -y

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
# Pour build :
# cd dans flask-docker-test puis :
docker build -f Dockerfile.api -t react-flask-app-api .

# Pour run :
docker run --rm -p 5000:5000 react-flask-app-api
