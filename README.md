docker network create --driver overlay --attachable proxy

git clone https://github.com/KyleFS/docker-dev-infrastructure devtainer

cd devtainer

mv .env.sample .env

nano .env

sudo docker stack deploy -c docker-compose.yml devtainer

