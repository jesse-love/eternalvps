# 🗺️ Project Roadmap: The Autonomous Cloud Agency

**Mission**: Transform Eternal Services into an AI-driven, chat-operated sales and SEO agency using Mattermost, N8n, and Cloudflare.

## Phase 1: The Command Center (Mattermost + N8n Loop) 🚧 *[Current Focus]*
**Goal**: Establish the communication loop where the user chats in Mattermost, and an AI agent (via N8n) responds and takes action.
- [ ] **Mattermost Setup**: Create "Agent" bot users.
- [ ] **N8n Webhook**: Create a workflow to receive Mattermost messages.
- [ ] **LLM Integration**: Connect N8n to OpenAI/Anthropic/Ollama.
- [ ] **Response Loop**: Send LLM responses back to Mattermost.

## Phase 2: The Tooling Layer (Cloudflare Ecosystem)
**Goal**: Equip the AI with "hands" using Cloudflare Workers and Gateway.
- [ ] **SEO Worker**: Build a Cloudflare Worker to scrape/analyze websites (Lighthouse, meta tags).
- [ ] **Content Worker**: Build a Worker to update site content (CMS integration).
- [ ] **Cloudflare Gateway**: Securely manage outgoing agent traffic.

## Phase 3: Eternal Action (The Brain & MCP)
**Goal**: Create a central logic unit ("Eternal Action") that standardizes tool access.
- [ ] **MCP Implementation**: Build a Model Context Protocol server (or similar) on Cloudflare Workers.
- [ ] **Tool Registry**: Define available actions (Sales, SEO, SysAdmin) for the AI.

## Phase 4: Memory & Knowledge (R2 + Vectorize)
**Goal**: Enable long-term memory and context-aware agents.
- [ ] **Cloudflare Vectorize**: Implement a vector database for chat history and knowledge.
- [ ] **R2 Storage**: Store documents (PDFs, reports) and sync them to the knowledge base.
- [ ] **Contextual Retrieval**: Agents query Vectorize before answering.

## Phase 5: "Stateless" Citadel (Infrastructure)
**Goal**: Ensure the entire stack is resilient and easily redeployable.
- [ ] **Backups**: Auto-sync Docker volumes to R2.
- [ ] **IaC**: Fully define infrastructure in code (Terraform or just polished Compose/Scripts).
