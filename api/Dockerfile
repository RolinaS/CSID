# Utilisation de Node.js comme image de base
FROM node:18-alpine

# Définition du répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du code source
COPY . .

# Exposer le port 8000
EXPOSE 8000

# Démarrer l'application
CMD ["npm", "run", "dev"]
