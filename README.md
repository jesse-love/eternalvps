# 🌌 Eternal Services: The Mission Brief

**Mission**: Engineering incorruptible, stateless, and AI-led infrastructure.
**Hero Architect**: Jesse Love
**Tactical Operatives**: Chris & AI-Managed Agents

This repository is the source of truth for the **Eternal Services** Digital Citadel. It is a completely self-hosted, cloud-proxied, and AI-integrated ecosystem.

## 🚀 Quick Start

### Activation
To activate the custom terminal environment (aliases, prompt, and pathing):
```bash
source ~/.bashrc
```

### Management
The core infrastructure (Traefik, Portainer, Tunnel) is managed via Docker Compose:
```bash
cd core
docker compose up -d
```

---

## 🛠 Project Components

### 1. Networking Stack (`core/`)
*   **[Traefik v3](https://traefik.io/traefik/)**: The primary edge router and reverse proxy. It automatically detects new Docker containers and routes traffic based on labels.
    *   **Dashboard**: [https://traefik.eternalservices.ca/dashboard/](https://traefik.eternalservices.ca/dashboard/)
*   **[Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/)**: A secure, outbound-only uplink providing public access to `*.eternalservices.ca` without opening firewall ports.
*   **[Portainer](https://www.portainer.io/)**: A web-based GUI for managing Docker containers, images, and volumes.
    *   **Live at**: [https://portainer.eternalservices.ca](https://portainer.eternalservices.ca)

### 2. Development Tooling
The VPS is pre-provisioned with a modern toolset:
*   **AI Pair Programming**: `aider` (AI in your terminal).
*   **Cloud CLIs**: `wrangler` (Cloudflare Workers/Pages), `neonctl` (Neon Serverless DB).
*   **Environment**: Node.js v20, Python 3, NPM.

---

## 💎 Terminal "Pimping"

Your shell has been upgraded for maximum productivity:

| Tool | Alias | Description |
| :--- | :--- | :--- |
| **Starship** | - | Cross-shell, ultra-fast prompt. |
| **Bat** | `cat` | Syntax highlighting for code files. |
| **Eza** | `ls` | Improved file listing with icons and metadata. |
| **Zoxide** | `z` | Smart `cd` that learns your most visited folders. |
| **Fzf** | - | Fuzzy finder for files and history. |
| **Btop** | - | Interactive resource monitor (CPU/RAM/Net). |
| **Micro** | - | Intuitive, mouse-aware terminal text editor. |
| **Tldr** | `help` | Simplified, example-based man pages. |

---

## 🔧 Adding New Services

To deploy a new application behind `eternalservices.ca`:

1.  Add the service to `core/docker-compose.yml` (or a separate compose file on the `eternal-network`).
2.  Add the following labels to your service:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.MYAPP.rule=Host(`MYAPP.eternalservices.ca`)"
  - "traefik.http.services.MYAPP.loadbalancer.server.port=8080" # Change to internal app port
```

3.  Restart the stack: `docker compose up -d`.
4.  The site will be live immediately at `https://MYAPP.eternalservices.ca`.

---

## 📝 Configuration Details
*   **Network**: All services must join the `eternal-network` (Docker bridge).
*   **DNS**: Cloudflare Tunnel routes `*.eternalservices.ca` to the `cloudflared` container, which forwards traffic to `traefik:80`.
*   **Identity**: Git is configured for `jesse-love (me@jessejames.love)`.