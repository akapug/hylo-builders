# Product Requirements Document (PRD)

## Project: **Hylo‑Builders** (working title)

*Fork of Hylo.com re‑targeted as the community layer for builders.dev*

---

### 1  Purpose / Vision

Deliver a locally running fork of Hylo that serves as **THE social-project layer on top of GitHub**, providing a community space where developers can collaborate with flexible AI assistance. The platform will be re‑branded, deeply GitHub‑integrated, and support **extensible AI assistance through a plugin architecture** so early users can:

1. Create or join holonic groups for their coding projects
2. Seamlessly link those groups to one or more GitHub repositories
3. Leverage various AI assistants for insights, code analysis, and project management within each group

This MVP keeps the existing Node/GraphQL stack intact; Elide is a future upgrade path.

---

### 2  Goals & Non‑Goals

|                | In‑Scope (Sprint 0‑1)                   | Out of Scope (later)                     |
| -------------- | --------------------------------------- | ---------------------------------------- |
| **Run fork**   | Local Docker + cloud dev env (Windsurf) | Full CI/CD pipeline                      |
| **Branding**   | builders.dev colors + logo swap         | Custom mobile apps                       |
| **Auth**       | GitHub OAuth + magic‑link email         | SSO, federation                          |
| **AI Plugins** | Extensible plugin architecture         | Advanced sandboxing, multi-agent orchestration |
| **Repo link**  | Deep GitHub integration with groups     | Advanced metrics & analytics platform     |
| **UI**         | Minimal tweaks for AI assistant sidebar | New design system                        |
| **Governance** | Keep Hylo roles (member/mod/admin)      | Co‑op tokenomics                         |

---

### 3  Personas & Key Use Cases

1. **Solo Builder (Dev)** – wants feedback on repo health, code quality, and next feature suggestions through integrated AI assistance.
2. **Non‑Dev Founder** – creates a group, links Figma + GitHub, uses AI assistants to generate technical roadmaps and translate designs into development tasks.
3. **Maintainer Squad** – migrates existing OSS tool into a holon, uses group chat with AI support to triage issues, prioritize work, and onboard new contributors.
4. **Open Source Community** – coordinates across multiple repositories with customized AI plugins tailored to their specific development workflows and documentation needs.

---

### 4  Functional Requirements

| FR‑ID | Description                                                                         | Priority |
| ----- | ----------------------------------------------------------------------------------- | -------- |
| FR‑01 | Fork Hylo repo; rename app, env vars, seed data                                     | P0       |
| FR‑02 | Docker compose for Postgres + Node + Next                                           | P0       |
| FR‑03 | Enable GitHub OAuth (passport‑github) as primary authentication method             | P0       |
| FR‑04 | Deep GitHub integration: connect repositories to groups with metadata sync          | P0       |
| FR‑05 | Extensible AI Plugin Interface with standardized API                                | P0       |
| FR‑06 | Plugin marketplace structure supporting multiple AI assistant options               | P1       |
| FR‑07 | Group sidebar: AI assistant chat panel with context-aware repository insights       | P1       |
| FR‑08 | Admin controls for plugin configuration and permissions per group                   | P1       |
| FR‑09 | Repository analytics dashboard: activity, health metrics, and contributor insights  | P2       |

---

### 5  Non‑Functional Requirements

* **Local dev ≤ 1 command** (`make dev` or `docker compose up`).
* **Latency** for AI assistant replies ≤ 5 s (streamed).
* **Privacy**: store only public GitHub data + minimal OAuth tokens.
* **Extensibility**: plugin system must support multiple AI assistants without code changes.
* **Interoperability**: seamless integration with GitHub APIs and workflows.
* **Security**: proper sandboxing for third-party AI plugins to prevent security risks.

---

### 6  Milestones & Timeline *(LOC ≈ effort guide)*

| Phase    | Target LOC | Deliverables                                                |
| -------- | ---------- | ----------------------------------------------------------- |
| Sprint 0 | +800 LOC   | Fork compiles locally, branding swapped, Docker infra       |
| Sprint 1 | +1200 LOC  | GitHub OAuth + Deep Repository Integration + Plugin System  |
| Sprint 2 | +1500 LOC  | AI Assistant UI, Plugin Marketplace, Repository Analytics   |

---

### 7  Risks & Mitigations

| Risk                      | Impact                    | Mitigation                                   |
| ------------------------- | ------------------------- | -------------------------------------------- |
| AI API changes/downtime   | Assistant functionality fails | Version-pinning, fallbacks, multiple providers |
| GitHub rate limits        | Repository data delays    | Intelligent caching & worker queue system     |
| Plugin security concerns  | Potential RCE vulnerabilities | Comprehensive sandboxing for all plugins      |
| OAuth token management    | Security & privacy risks  | Secure storage, minimal scopes, token rotation|
| User adoption complexity  | Slow community growth     | Intuitive onboarding, templates, documentation|

---

### 8  Metrics (post‑MVP)

* # active groups / day
* % groups with linked repositories
* % groups using AI plugins
* Repository connection retention rate
* Average AI assistant interactions per session
* Time-to-value metrics (first PR, issue resolution, etc.)
* Cross-repository collaboration frequency

---

### 9  Open Questions

1. What sandboxing approach provides the best balance of security and flexibility for AI plugins?
2. How should we structure the plugin marketplace to accommodate various AI assistant options?
3. What level of GitHub API integration is needed for MVP vs. future versions?
4. How to handle AI credential management across different providers (env vs encrypted table)?
5. What repository metrics are most valuable for different user personas?
6. How to design the plugin system for maximum extensibility while maintaining security?

---

**Maintainer:** David Anderson · May 2025
