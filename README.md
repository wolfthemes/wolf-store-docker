# WolfThemes Store — Docker Dev Environment

Local WordPress development environment for the WolfThemes FSE theme and Store plugins.

[Staging Website](https://staging20.wolfthemes.com/store/)

_This is an example README and a personal reference point for starter commands._

## Stack

- WordPress (latest) + Apache + PHP 8.x — **FSE / Gutenberg only** (no Elementor, no page builders, no wolf-core)
- MySQL 8.0
- Adminer (DB GUI) at http://localhost:8081

### Projects developed here

| Path | Type | Role |
|---|---|---|
| `themes/wolf-blank` | FSE Theme | Base theme — design tokens, layout, templates |
| `themes/seijaku-fse` | FSE Theme | Child theme built on wolf-blank |
| `plugins/wolf-store` | Plugin | WooCommerce blocks, REST API |
| `plugins/wolf-blocks` | Plugin | Reusable Gutenberg blocks |

The theme owns all design tokens (colors, typography, spacing, radius, shadows) via
`theme.json` and `assets/css/global.css`. Plugins consume those CSS custom properties and
never hardcode design values. See `plugins/wolf-store/BOUNDARIES.md`.

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

### 2. Clone the theme and plugins

The `themes/` and `plugins/` folders are gitignored and cloned separately.

```bash
mkdir -p themes plugins

# FSE themes
git clone git@github.com:wolfthemes/wolf-blank.git themes/wolf-blank
git clone git@github.com:wolfthemes/seijaku-fse.git themes/seijaku-fse

# Plugins
git clone git@github.com:wolfthemes/wolf-store.git plugins/wolf-store
git clone git@github.com:wolfthemes/wolf-blocks.git plugins/wolf-blocks
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

Then activate the theme and plugins (via wp-admin, or WP-CLI — see below):

```bash
wp theme activate seijaku-fse
wp plugin activate wolf-store wolf-blocks
```

### 6. Start frontend development

```bash
cd plugins/wolf-store
npm install
npm run start
```

Webpack watches `src/` and writes to `build/`. Refresh **http://localhost:8080** to see
changes, or use port **3000** for hot reload. Repeat for any other package you're working
on (`plugins/wolf-blocks`, `themes/wolf-blank`).

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

WordPress debugging is enabled in `docker-compose.yml` (`WP_DEBUG`, `WP_DEBUG_LOG`,
`SCRIPT_DEBUG`). Debug output is logged to `wp-content/debug.log` inside the container.

---

## WP-CLI

### Installation

Install WP-CLI in the container:

```bash
docker exec -it wolf-store-docker-wordpress-1 bash -c "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp"
```

WP-CLI runs inside the WordPress container. To avoid typing the full `docker exec`
command every time, add this alias to your WSL `~/.bashrc`:

```bash
echo 'alias wp="docker exec -it wolf-store-docker-wordpress-1 wp --allow-root"' >> ~/.bashrc
source ~/.bashrc
```

Then use `wp` directly from WSL:

```bash
wp plugin list
wp plugin install woocommerce --activate
wp cache flush
```

## Useful URLs

| URL | What |
|---|---|
| http://localhost:8080 | WordPress frontend |
| http://localhost:8080/wp-admin | WordPress admin |
| http://localhost:8081 | Adminer DB GUI (server: `db`) |
| http://localhost:3000 | Webpack dev server (hot reload) |

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
├── config/
│   └── php.ini           ← custom PHP config mounted into the container
├── themes/               ← gitignored, cloned separately
│   ├── wolf-blank/
│   └── seijaku-fse/
└── plugins/              ← gitignored, cloned separately
    ├── wolf-store/
    └── wolf-blocks/
```

---

## Notes

- `themes/` and `plugins/` are **live-mounted** into the container — edits on your host
  reflect instantly, no restart needed.
- WordPress core and any third-party plugins (e.g. WooCommerce) live in the persistent
  `wp_data` Docker volume, installed via WP-CLI or wp-admin.
- The `build/` folder in each plugin is committed to git (no server-side webpack
  compilation on shared hosting).
- `config/php.ini` is mounted as a custom PHP config; adjust limits there if needed.
