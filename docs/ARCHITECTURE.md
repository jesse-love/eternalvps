# 🏗️ System Architecture

## Overview
The **Eternal Services** ecosystem operates as a hybrid stack:
1.  **Core Infrastructure**: Docker containers on a VPS (Traefik, Mattermost, N8n).
2.  **Execution Layer**: Serverless functions on Cloudflare (Workers, Pages).
3.  **Storage Layer**: Cloudflare R2 (Object Storage) and Vectorize (Memory).

## Data Flow: The "Agent Loop"

```mermaid
graph TD
    User[User (Jesse)] -->|Chat| MM[Mattermost (VPS)]
    MM -->|Webhook| N8n[N8n (VPS)]
    
    subgraph "Brain & Tools"
        N8n -->|API Call| LLM[LLM (OpenAI/Anthropic)]
        N8n -->|Execution| CF_W[Cloudflare Workers]
        
        CF_W -->|SEO Audit| Internet[External Websites]
        CF_W -->|Store/Retrieve| R2[Cloudflare R2]
        CF_W -->|Recall| Vec[Cloudflare Vectorize]
    end
    
    LLM -->|Response| N8n
    CF_W -->|Result| N8n
    N8n -->|Reply| MM
```

## Components

### 1. Mattermost (The Interface)
-   **Role**: The primary UI for interacting with the system.
-   **Integration**: Outgoing Webhooks point to N8n triggers. Incoming Webhooks allow agents to post proactive messages.

### 2. N8n (The Orchestrator)
-   **Role**: Connects the chat interface to the logic and tools.
-   **Workflows**:
    -   *Router*: Decides which agent (Sales, SEO, Admin) handles a request.
    -   *Executor*: Calls the specific Cloudflare Worker or API.

### 3. Cloudflare Workers (The Hands)
-   **Eternal Action**: A planned central Worker that acts as a tool registry.
-   **SEO-Bot**: A specialized worker for fetching and analyzing pages.
-   **Sales-Bot**: A worker connecting to CRM/Email tools.

### 4. Storage
-   **Local (VPS)**: Docker volumes for immediate application state (Postgres DBs).
-   **Cloud (Cloudflare)**:
    -   **R2**: Backups, file storage, knowledge base documents.
    -   **Vectorize**: Semantic index for long-term memory.
