# CLAUDE.md

Guidance for working in this workspace.

## ⚠️ Multiple independent Git repositories

This workspace is **not a monorepo**. The root is one Git repo, and several
project directories nested under it are **separate, independent Git repos** —
each with its own remote, branch, and commit history. The nested project repos
are gitignored by the root repo (see `.gitignore`) and cloned separately.

| Path | Remote | Default branch |
|---|---|---|
| `.` (root: Docker dev env) | `git@github.com:wolfthemes/wolf-store-docker.git` | `master` |
| `themes/wolf-blank` | `git@github.com:wolfthemes/wolf-blank.git` | `master` |
| `themes/seijaku-fse` | `git@github.com:wolfthemes/seijaku-fse.git` | `master` |
| `plugins/wolf-store` | `git@github.com:wolfthemes/wolf-store.git` | `dev` |
| `plugins/wolf-blocks` | `git@github.com:wolfthemes/wolf-blocks.git` | `master` |
| `plugins/allow-svg` | `git@github.com:wolfthemes/allow-svg.git` | `main` |

### Rules when working across projects

- **Never assume a commit in one repo affects another.** A change is only
  staged, committed, branched, or pushed in the single repo it lives in.
- **Git commands apply only to the repo you are currently inside.** Running
  `git` from the root operates on `wolf-store-docker`, not on the nested
  theme/plugin repos.
- **Check which repo you are in before any git operation:**
  ```bash
  git -C <path> remote -v
  ```
  Prefer `git -C <path> ...` to target a specific repo explicitly rather than
  relying on the current working directory.
- Branches differ per repo (e.g. `wolf-store` is on `dev`, others on
  `master`) — confirm the branch in the target repo before committing or
  pushing.
- When a task spans multiple projects, treat each repo's commits, PRs, and
  pushes independently.

## Project context

Local WordPress (FSE / Gutenberg only — no Elementor, no page builders, no
wolf-core) dev environment run via Docker. See `README.md` for setup, daily
workflow, WP-CLI, and URLs.

The theme owns all design tokens (colors, typography, spacing, radius, shadows)
via `theme.json` and `assets/css/global.css`. Plugins consume those CSS custom
properties and never hardcode design values — see
`plugins/wolf-store/BOUNDARIES.md`.
