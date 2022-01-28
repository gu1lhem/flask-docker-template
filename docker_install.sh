apt update
sudo apt install docker.io -y
sudo usermod -a -G docker $USER
newgrp docker
# Il faut peut-être se déconnecter puis reconnecter ici.

# Pour build :
# cd dans flask-docker-test puis :
docker build -f Dockerfile.api -t react-flask-app-api .

# Pour run :
docker run --rm -p 5000:5000 react-flask-app-api