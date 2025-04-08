# Utiliser l'image officielle de Ruby 3.2 comme base
FROM ruby:3.2.0

# Installer les dépendances nécessaires
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Ajouter les fichiers du projet dans le conteneur
COPY Gemfile Gemfile.lock ./

# Installer les gems
RUN bundle install

# Copier le reste des fichiers de l'application
COPY . .

# Précompiler les assets si nécessaire (pour une version de production)
# RUN RAILS_ENV=production bundle exec rake assets:precompile

# Exposer le port de l'application Rails
EXPOSE 3000

# Commande pour démarrer le serveur
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
