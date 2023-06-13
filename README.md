# CONTEXTE DU PROJET 

Le projet Dealabs-scraper est une application qui permet d'obtenir les meilleurs deals du site Dealabs. Il utilise Docker Compose pour créer un environnement de développement dans un conteneur. Cela facilite le déploiement et l'exécution cohérente de l'application sur différentes machines.

Le projet est configuré pour utiliser Nginx comme load balancer et reverse proxy. Nginx permet de distribuer la charge entre plusieurs instances de l'application et d'acheminer les requêtes des utilisateurs vers les différentes instances. Cela permet d'améliorer la disponibilité et la scalabilité de l'application.

L'utilisation de Docker Compose et Nginx facilite également la mise en place d'un environnement local pour le développement et les tests. Les développeurs peuvent travailler sur le projet de manière isolée, sans se soucier des dépendances et de la configuration de l'environnement.

Ce projet est conçu pour une utilisation en local. Pour un déploiement en production, il serait nécessaire de prendre en compte des considérations supplémentaires telles que la sécurité, la mise à l'échelle horizontale et la haute disponibilité.

[Screencast from 06-13-2023 09:46:42 PM.webm](https://github.com/yunghope/Cloud/assets/129152878/d73a3c62-6a44-4507-a4d4-c381edc61c90)

-----
### REMINDER

#### Starts all stopped containers in the work directory
docker-compose start
#### Stops all currently running containers in the work directory
docker-compose stop
#### Validates and shows the configuration
docker-compose config
#### Lists all running containers in the work directory
docker-compose ps
#### Stops and removes all containers in the work directory
docker-compose down
