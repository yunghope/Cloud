Docker compose
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


---
### Crée ou prendre un projet en utilisant Docker-compose afin de déployer les différents conteneurs en même temps et manière automatisé

##### Images docker - Dealabs-scrapper-app (Sélecteur des meilleurs deals de dealabs)

#### Création d'un docker-compose.yml

- Création du docker-compose.yml dans le dossier du projet Dealabs-scrapper-app.
```
version: '3.7'
services:
#Définit les services à exécuter
  app:
    build:
      context: .
    stdin_open: true
    tty: true
#Ouvre une connexion interactive avec le conteneur
    volumes:
      - ./app:/app
server.address 0.0.0.0 --logger.level: error

##################

  nginx:
    image: nginx
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
    ports:
      - 80:80
````

#### Création du Dockerfile
- Création du Dockerfile dans le dossier du projet dealabs-scrapper-app
```
FROM python:3.9-slim

WORKDIR /app

###################
# affiche immédiatement sans mise en mémoire tampon
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8
###################
#spécifie les origines autorisées pour les requêtes
ENV STREAMLIT_ALLOWED_ORIGINS="http://atqg"
ENV STREAMLIT_USE_EXTERNAL_AUTH_TOKEN=false
###################

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*
###################

COPY requirements.txt .

###################
# Clone du projet + Installation des dépendances python + Package python altair
RUN git clone https://github.com/erazoor/dealabs-scraper.git

RUN pip3 install -r requirements.txt

RUN pip install altair vega_datasets

###################
#Vérification de l'état de santé du conteneur en effectuant une requête HTTP sur l'URL
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

#browser.serverAddress 0.0.0.0 > /dev/null 2>&1

###################

ENTRYPOINT ["streamlit", "run", "dealabs-scraper/main.py", "--server.port=8501", "--server.address=0.0.0.0"]
````

#### Vérification du requirements.txt
- Ajouter la dépendance Altair
`````
requests~=2.28.1
streamlit~=1.17.0
beautifulsoup4~=4.11.1
Jinja2~=3.1.2
altair<5
`````

#### Création du dossier et fichier nginx
- Création du dossier nginx dans le projet dealabs-scrapper-app puis création du fichier nginx.conf

`````
events {
  worker_connections  1024;
  #nombres de connexions simultanées
}

http {
 proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=cache:10m max_size=10g inactive=60m use_temp_path=off;
 #définit le chemin de cache
 upstream app {
    server app:8501;  # Nom du service Docker pour l'application Streamlit - définit un groupe de serveurs backend appelé "app"
  }

  server {
    listen 80;
    server_name atqg;

    location / {
      proxy_pass http://app; #redirige les requêtes vers le groupe de serveurs backend "app"
      proxy_set_header Host $host; #spécifient les en-têtes HTTP à envoyer au backend pour inclure des informations telles que l'adresse IP
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache cache; #activent la mise en cache des réponses du backend pour améliorer les performances.
      proxy_cache_valid 200 301 302 10m;
      proxy_cache_valid any 5m;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
    }
  }
}
`````

docker-compose up -d --build
	
/home/yung/Documents/dealabs-scraper
docker images : dealabs-scrapper-app


docker exec -it dealabs-scraper_app_1 bash
python dealabs-scraper/main.py
streamlit run dealabs-scraper/main.py 

docker logs (image)

------



