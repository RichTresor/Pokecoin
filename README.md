# Pokecoin

Rails API + Vue 3 (Vite) frontend, packaged with Docker Compose.

Services:
- API (Rails): http://localhost:3000
- Frontend (nginx serving Vite build): http://localhost:8080
- PostgreSQL: internal to Docker (db service)

## Prerequisites

- Docker Desktop (Windows/macOS/Linux)
- Git

Windows users: use PowerShell. All commands below assume you run them from the project root.

## Quick start

1) Build and start all services

```powershell
docker compose up -d --build
docker compose logs -f
```

2) Initialize the database (creates schema and seeds demo data)

```powershell
docker compose exec api bundle exec rails db:prepare
docker compose exec api bundle exec rails db:seed
```

3) Open the app

- Frontend: http://localhost:8080
- API root: http://localhost:3000

## Demo accounts and data

`db/seeds.rb` creates users and 10 Pokémon cards assigned to them.

- Users:
	- test@example.com / password123 (balance: 1000)
	- user1@example.com / password123 (balance: 500)
	- user2@example.com / password123 (balance: 750)
	- admin@example.com / admin123 (balance: 10000)

Cards get official artwork image URLs from PokéAPI and are assigned to users in round‑robin.

## Useful commands

- Show running services
```powershell
docker compose ps
```

- Follow API logs
```powershell
docker compose logs -f api
```

- Reset database (development only)
```powershell
# Safe reset in development
docker compose exec -e RAILS_ENV=development api bundle exec rails db:drop db:create db:migrate db:seed

# If Rails insists on production, bypass the protection (dev only!)
docker compose exec -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 api bundle exec rails db:reset
```

- Inspect DB tables
```powershell
docker compose exec db psql -U postgres -d pokecoin_api_development -c "\dt"
docker compose exec db psql -U postgres -d pokecoin_api_development -c "SELECT id, name, user_id FROM cards LIMIT 10;"
```

- Run tests (RSpec)
```powershell
docker compose exec api bundle exec rspec
```

## Configuration notes

- CORS is enabled for `http://localhost:8080` in `config/initializers/cors.rb` so the frontend can call the API.
- Database and secrets are provided via Docker Compose environment variables. You should not need a local Ruby or Node install.
- The frontend image builds the Vite app and serves static files with nginx.

## Development tips

- SPA routing: frontend nginx is configured to serve `index.html` for unknown routes (e.g., `/signup`). If you see 404s on deep links, ensure the nginx config is in place (it should be copied in the frontend Dockerfile).
- Windows line endings: if you see `shebang line ending with \r may cause problems`, convert CRLF to LF inside the container:
	```powershell
	docker compose exec api bash -lc "sed -i 's/\r$//' bin/* db/seeds.rb"
	```

## Troubleshooting

- Port 3000 already in use:
	```powershell
	netstat -ano | findstr :3000
	# Stop the conflicting process (replace <PID>)
	taskkill /PID <PID> /F
	```
	Or change the host port mapping for the API in `docker-compose.yml` (e.g., `3001:3000`).

- API not starting due to gem issues
	```powershell
	docker compose run --rm api bundle install
	docker compose up -d api
	docker compose logs -f api
	```

- Frontend 404 on routes like `/signup`:
	Ensure nginx `try_files $uri $uri/ /index.html;` is present in the frontend image config.

- CORS errors from the browser:
	`config/initializers/cors.rb` should include `origins 'http://localhost:8080'` and allow common methods. Restart the API after changes.

## Project structure

- Rails app (API): root directory
- Frontend (Vue 3 + Vite): `pokecoin-frontend/`
- Docker Compose: `docker-compose.yml`
- Seeds: `db/seeds.rb`

## Contributing

1. Fork the repo and create your feature branch.
2. Commit your changes with clear messages.
3. Run tests and ensure the Docker stack builds/starts.
4. Open a pull request.

