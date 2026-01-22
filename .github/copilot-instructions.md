## Project quick facts

- Name: Eternal Services (eternalvps)
- Purpose: Self-hosted, Docker Compose–driven "Digital Citadel" using Traefik as the edge router and Cloudflare Tunnel for outbound public exposure.
- Where to run core stack: repository root / `core` (compose is in repo root but uses `core/` for cloudflared config).

## What an AI agent should know first

- The system is deployed via Docker Compose. The main compose file is at the repository root: `docker-compose.yml`.
- Networking: services join the `eternal-network` Docker bridge. Traefik reads Docker labels to configure routing. Cloudflared (Cloudflare Tunnel) reads `core/config.yaml` and `core/credentials.json`.
- Add new services by adding them to `docker-compose.yml` (or a separate compose file attached to `eternal-network`) and by applying the Traefik labels shown in `README.md` / `docker-compose.yml`.

## Common developer workflows (explicit commands)

- Start core infra (from repo root):

  cd core
  docker compose up -d

- Add/replace service, then reload stack:

  # edit docker-compose.yml
  docker compose up -d

- Hub (frontend) development (apps/hub):

  cd apps/hub
  npm install
  npm run dev

- The repository provides `install.sh` to bootstrap a fresh VPS (installs Docker, Node 20, CLIs such as wrangler, neonctl, and tools like starship, bat, eza). Read it to reproduce environment setup.

## Project-specific patterns and conventions

- Traefik labels are authoritative for public routing. Required labels when adding a new service:

  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.MYAPP.rule=Host(`MYAPP.eternalservices.ca`)"
    - "traefik.http.services.MYAPP.loadbalancer.server.port=8080" # the container's internal port

- Entrypoints: the compose file config shows Traefik entrypoint `web` bound to :80 (TLS is terminated upstream by Cloudflare Tunnel). Use `entrypoints=web` when appropriate.
- Exposed-by-default is disabled in Traefik (`providers.docker.exposedbydefault=false`) so each service must explicitly opt in with `traefik.enable=true`.

## Key files to reference (examples)

- `docker-compose.yml` — service definitions, Traefik, cloudflared, Portainer, n8n, and postgres example.
- `core/config.yaml` and `core/credentials.json` — Cloudflared tunnel configuration (mounted into `cloudflared` container).
- `install.sh` — step-by-step bootstrap used to provision the VPS (useful for reproducing dev environment).
- `apps/hub/` — small Vite + React app; `package.json` shows scripts: `dev`, `build`, `lint`, `preview`. Example component: `apps/hub/src/App.jsx`.

## Safety and secrets

- Do NOT commit secrets (e.g., Cloudflared credentials, DB passwords). This repo currently contains `core/credentials.json` and some env-like values for convenience; treat them as sensitive in other contexts.
- When writing code that touches deployment configs, prefer documenting required secrets and use placeholders in commits.

## Helpful examples for quick edits

- To add a new web app behind Traefik (example):

  1. Create a service block in `docker-compose.yml` that attaches to `eternal-network`.
  2. Add the three Traefik labels above, replacing `MYAPP` with a short identifier (lowercase, no spaces).
  3. Expose the app's internal port in the `traefik.http.services.*.loadbalancer.server.port` label.
  4. Run `docker compose up -d` to apply changes.

## What not to change lightly

- `docker-compose.yml` network name `eternal-network` — other services depend on this exact name.
- Traefik provider flags in the compose file — changing `exposedbydefault` or provider behavior will change routing defaults across the entire stack.

## Editor/formatting conventions

- Frontend `apps/hub` uses ES modules and React 18. Use `npm run lint` (ESLint) in that directory for quick checks.

## If you need more context

- Read `README.md` for architecture rationale and the `install.sh` for environment provisioning steps.
- Inspect `apps/*` directories for app-specific patterns (e.g., `apps/hub` is Vite + React).

---

If anything above is unclear or you want me to expand a section (deploy details, example PR, or checklists for adding services), tell me which part and I'll iterate.
