# Wordpress Devtainer

##Initial Setup
Clone this project and enter the directory.
```
git clone https://github.com/KyleFS/docker-dev-infrastructure devtainer
cd devtainer
```

Fill in the environmental variable file. ADMIN_EMAIL is used for Let's Encrypt SSL.
```
mv .env.sample .env
nano .env
```

Create the 'proxy' network which connects Traefik to the Apache instances.
```
sudo docker network create --driver overlay --attachable proxy
```
Deploy the infrastructure stack under the name 'devtainer'
```
sudo docker stack deploy -c docker-compose.yml devtainer
```

In order to use the Wordpress Dev templates, the following Docker secrets also need to be set:
- mysql_root_password
- wordpress_user
- wordpress_password
