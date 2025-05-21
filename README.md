# Wordpress Devtainer

## Prepare Docker
- Set up the Docker repository(https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository)
- Set up the Docker Engine(https://docs.docker.com/engine/install/ubuntu/)
- Set up Docker Compose Plugin

Set Up Swarm:
```
sudo docker swarm init
```

Create the 'proxy' network which connects Traefik to the Apache instances.
```
sudo docker network create --driver overlay --attachable proxy
sudo docker network create --driver overlay --attachable devtainer_agent_network
```

In order to use the Wordpress Dev templates, the following Docker secrets also need to be set:
- mysql_root_password
- wordpress_user
- wordpress_password
- AUTHELIA_JWT_SECRET_FILE (It’s strongly recommended this is a Random Alphanumeric String with 64 or more characters.)

Example Docker Secret creation derived from their documentation:
```
printf "I am a sql password" | sudo docker secret create mysql_root_password -
```

## Prep the stack

Clone this project and enter the directory.
```
cd /opt
git clone https://github.com/KyleFS/docker-dev-infrastructure devtainer
cd devtainer
```

Fill in the environmental variable file. DEV_ADMIN_EMAIL is used for Let's Encrypt SSL.
```
mv .env.sample .env
nano .env
```

Create the log directory:
```
sudo mkdir /var/log/docker-dev
sudo chown www-data:www-data /var/log/docker-dev
```

Create the SFTP config:

```
sudo mkdir -p /opt/docker-dev/conf/sftp
sudo nano /opt/docker-dev/conf/sftp/users.conf
```

Add the following user, pass, UUID, GUID to the SFTP conf.
```
wordpress:wordpress:33:33
```

Create the shared directory
```
sudo mkdir -p /opt/docker-dev/shared
```

## Planka
Make a entropy secret.
```
HASH=$(date +%s | openssl dgst -sha256 | awk '{print $2}') && echo "$HASH" | sudo docker secret create planka_secret
```

## Run the stack
Deploy the infrastructure stack under the name 'devtainer'
```
cd /opt/devtainer
sudo docker stack deploy -c docker-compose.yml devtainer
```
