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
