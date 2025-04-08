# Utiliser l'image officielle de Node.js comme base
FROM node:16

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers du projet
COPY . .

# Installer les dépendances
RUN npm install

# Construire l'application Vue.js
RUN npm run build

# Exposer le port pour Vue.js
EXPOSE 8080

# Lancer l'application Vue.js
CMD ["npm", "run", "serve"]
