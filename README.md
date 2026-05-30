# WolfThemes Store — Docker Dev Environment

Local WordPress development environment for the WolfThemes Store plugin. 

[Staging Website](https://staging20.wolfthemes.com/store/)

_This is an example of README file and a personal reference point for Docker commands_

## Stack

- WordPress (latest) + Apache + PHP
- MySQL 8.0
- Adminer (DB GUI) at http://localhost:8081

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Git
- Node.js + npm (for webpack/frontend work)
- SSH access

---

## First-Time Setup

### 1. Clone this repo

```bash
git clone <this-repo-url> wolf-store-docker
cd wolf-store-docker
```

### 2. Clone what you need

```bash
mkdir plugins

# Wolf Store plugin
git clone git@github.com:wolfthemes/wolf-store.git plugins/wolf-store
```

### 3. Set up your environment variables

```bash
cp .env.example .env
```

Edit `.env` and set your own passwords (anything works locally).

### 4. Start the containers

```bash
docker compose up -d
```

First run will pull the Docker images — takes about a minute.

### 5. Run the WordPress installer

Go to **http://localhost:8080** and complete the 5-minute WordPress setup.  
Use any username/password you like — this is local only.

### 6. Start frontend development

```bash
cd plugins/wolf-store
npm install
npm run start
```

Webpack watches `src/` and writes to `build/`. Refresh **http://localhost:8080** to see changes instantly or use the port **3000**.

---

## Daily Workflow

```bash
# Start
docker compose up -d

# Stop (data is preserved)
docker compose stop

# View PHP logs
docker compose logs -f wordpress

# Full reset (wipes DB and WP install)
docker compose down -v
```

---

## WP-CLI

## Installation

Install WP-CLI in the container

```bash
docker exec -it wolf-store-docker-wordpress-1 bash -c "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp"
```

WP-CLI runs inside the WordPress container. To avoid typing the full `docker exec` command every time, add this alias to your WSL `~/.bashrc`:

```bash
echo 'alias wp="docker exec -it wolf-store-docker-wordpress-1 wp --allow-root"' >> ~/.bashrc
source ~/.bashrc
```

Then use `wp` directly from WSL:

```bash
wp plugin install customizer-export-import --activate
wp plugin list
wp cache flush
```

## Useful URLs

| URL | What |
|---|---|
| http://localhost:8080 | WordPress frontend |
| http://localhost:8080/wp-admin | WordPress admin |
| http://localhost:8081 | Adminer DB GUI (server: `db`) |

### Adminer login
- **Server:** `db`
- **Username:** value of `DB_USER` in your `.env`
- **Password:** value of `DB_PASSWORD` in your `.env`
- **Database:** value of `DB_NAME` in your `.env`

---

## Project Structure

```
wolf-store-docker/
├── docker-compose.yml
├── .env                  ← gitignored, your local secrets
├── .env.example          ← committed, safe placeholder values
├── .gitignore
├── README.md
├── plugins/              ← gitignored, cloned separately
    └── wolf-store/
```

---

## Notes

- `plugins/` folder is **live-mounted** into the container — edits on your host reflect instantly, no restart needed.
- Third-party plugins (Wolf Core, Elementor) are installed inside the persistent `wp_data` Docker volume via Seijaku's plugin installer.
- The `build/` folder in Wolf Store is committed to git (no server-side webpack compilation on shared hosting).
