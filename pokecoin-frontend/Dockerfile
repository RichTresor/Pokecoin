# Utiliser l'image officielle de Node.js comme base
FROM node:18

# Définir le répertoire de travail
WORKDIR /app

# Copier uniquement les fichiers nécessaires pour installer les dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers du projet
COPY . .

# Construire l'application Vue.js
RUN npm run build

# Exposer le port pour Vue.js
EXPOSE 8080

# Lancer l'application Vue.js
CMD ["npm", "run", "preview"]
