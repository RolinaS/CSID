# Utilisation de Node.js comme image de base
FROM node:18-alpine

# Définition du répertoire de travail
WORKDIR /app

# Copie des fichiers package.json et package-lock.json
COPY package*.json ./

# Installation des dépendances
RUN npm install

# Copie du reste des fichiers du projet
COPY . .

# Construction de l'application
RUN npm run build

# Exposition du port 5173 (port par défaut de Vite)
EXPOSE 5173

# Démarrage de l'application
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
