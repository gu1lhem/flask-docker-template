#!/bin/bash

# Pour le dépôt, il faut créer une paire de clés (voir https://github.com/appleboy/ssh-action)
# Et exécuter 
ssh "example.com" ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub | cut -d ' ' -f2
# sur la machine pour obtenir la fingerprint (mettre tout le résultat de la commande comme secret).
# puis ajouter la clé publique au fichier .ssh/authorized_keys.

key_file="flask-docker-test"

# Install Docker and Nginx
sudo apt update
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt install docker.io docker-compose nginx -y

# Create usergroup for Docker to be executed without root
sudo usermod -a -G docker $USER
newgrp docker

# Clés SSH pour GitHub
ssh-keygen -f .ssh/$key_file -N ""
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

# Pour installer un service systemd :
chmod +x ./systemd.sh
sudo ./systemd.sh


# Autoriser l'utilisateur à exécuer la commande restart pour ce service.
echo "Copiez ceci dans sudo visudo pour permettre le redémarrage automatique du service."
echo $(whoami)" ALL=NOPASSWD:/bin/systemctl restart "$(basename $(pwd))".service"

# From :
# https://github.com/appleboy/ssh-action
# https://blog.miguelgrinberg.com/post/how-to-dockerize-a-react-flask-project
# https://www.toptal.com/flask/flask-production-recipes
# https://techoverflow.net/2020/10/24/create-a-systemd-service-for-your-docker-compose-project-in-10-seconds/
