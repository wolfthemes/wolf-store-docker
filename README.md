# Wolf Store — Docker Dev Environment

Local WordPress development environment for the Wolf Store plugin frontend.  
Mirrors the staging setup at staging20.wolfthemes.com.

## Stack

- WordPress (latest) + Apache + PHP
- MySQL 8.0
- Adminer (DB GUI) at http://localhost:8081

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Git
- Node.js + npm (for webpack/frontend work)
- SSH access to WolfThemes repos

---

## First-Time Setup

### 1. Clone this repo

```bash
git clone <this-repo-url> wolf-store-docker
cd wolf-store-docker
```

### 2. Clone the plugins and themes

```bash
mkdir -p plugins themes

# Wolf Store plugin
git clone git@github.com:wolfthemes/wolf-store.git plugins/wolf-store

# Wolf Seijaku child theme
git clone git@github.com:wolfthemes/wolf-seijaku.git themes/wolf-seijaku
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

### 6. Install the Seijaku parent theme

- Go to **WP Admin → Appearance → Themes → Add New → Upload Theme**
- Upload your `seijaku.zip` file
- Activate Seijaku

### 7. Install required plugins via Seijaku's installer

After activating Seijaku, a notice will appear prompting you to install required plugins.  
This installs **Wolf Core**, **Elementor**, and other dependencies automatically.

### 8. Activate the child theme and Wolf Store

- Go to **Appearance → Themes** → activate **Wolf Seijaku**
- Go to **Plugins** → activate **Wolf Store**

### 9. Start frontend development

```bash
cd plugins/wolf-store
npm install
npm run watch
```

Webpack watches `src/` and writes to `build/`. Refresh **http://localhost:8080** to see changes instantly.

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
wolf-store-dev/
├── docker-compose.yml
├── .env                  ← gitignored, your local secrets
├── .env.example          ← committed, safe placeholder values
├── .gitignore
├── README.md
├── plugins/              ← gitignored, cloned separately
│   └── wolf-store/
└── themes/               ← gitignored, cloned separately
    └── wolf-seijaku/
```

---

## Notes

- `plugins/` and `themes/` are **live-mounted** into the container — edits on your host reflect instantly, no restart needed.
- Third-party plugins (Wolf Core, Elementor) are installed inside the persistent `wp_data` Docker volume via Seijaku's plugin installer.
- The `build/` folder in Wolf Store is committed to git (no server-side webpack compilation on shared hosting).
