# Wordpress Devtainer

## Initial Setup

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

Create the 'proxy' network which connects Traefik to the Apache instances.
```
sudo docker network create --driver overlay --attachable proxy
sudo docker network create --driver overlay --attachable devtainer_agent_network
```
Deploy the infrastructure stack under the name 'devtainer'
```
sudo docker stack deploy -c docker-compose.yml devtainer
```

In order to use the Wordpress Dev templates, the following Docker secrets also need to be set:
- mysql_root_password
- wordpress_user
- wordpress_password
- AUTHELIA_JWT_SECRET_FILE (It’s strongly recommended this is a Random Alphanumeric String with 64 or more characters.)
