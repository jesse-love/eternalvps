# 🛠 Infrastructure Decisions & Log

### 2026-01-02: Wildcard Deployment via Cloudflare Tunnel
*   **Problem**: Cloudflare Dashboard-managed tunnels require manual CNAME creation for every subdomain and don't support wildcard routing through the UI easily in the standard tunnel configuration.
*   **Solution**: Switched to a **Local Configuration File** approach.
    *   Created `core/config.yaml` and `core/credentials.json`.
    *   Configured `ingress` rules to map `*.eternalservices.ca` -> `http://traefik:80`.
    *   This allows "Dynamic Deployment": Simply add a Traefik label to a container, and it goes live instantly without touching Cloudflare again.

### 2026-01-02: Node.js & Tooling Setup
*   Installed Node.js v20 via NodeSource.
*   Installed `wrangler` for Cloudflare Workers.
*   Installed `neonctl` for database management.
*   Installed `aider` via pip (breaking system packages intentionally for global access on VPS).

### 2026-01-02: Identity Configuration
*   Git global user set to `jesse-love`.
*   Email set to `me@jessejames.love`.
*   Verified SSH connection to GitHub.

### 2026-01-02: Label Management & Traefik Dashboard
*   Enabled Traefik API/Dashboard and exposed it at `traefik.eternalservices.ca/dashboard/`.
*   Centralized `X-Forwarded-Proto` middleware as `https-headers`.
*   Updated Portainer to use centralized middleware.
