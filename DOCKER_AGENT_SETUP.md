# Docker Agent Machine Setup

Run Nanobot in Docker on a dedicated machine where the agent has git (SSH), Slack, Gmail, and your workspace—so it can work like a colleague.

---

## 1. Clone and build

```bash
git clone <this-repo>
cd nanobot
docker compose build
```

---

## 2. First run and config

```bash
# Create default config and workspace inside the volume
docker compose run --rm nanobot onboard
```

Then add your credentials to `config.json`. The config lives inside the Docker volume `nanobot_data`. To edit it:

**Option A – Copy config out, edit, copy back**

```bash
# Create a local copy (first time)
docker compose run --rm nanobot cat /root/.nanobot/config.json > config.local.json

# Edit config.local.json (add Slack, Gmail, LLM API key, etc.)

# Replace config in volume by running a one-off container that overwrites the file
# (e.g. mount config.local.json and copy into volume, or use docker cp after starting a temp container)
```

**Option B – Bind mount a host config file**

In `docker-compose.yml`, add a volume under `nanobot`:

```yaml
volumes:
  - nanobot_data:/root/.nanobot
  - ./config.json:/root/.nanobot/config.json:ro
```

Create `config.json` in the repo root (copy from `config.template.json`), edit it with your Slack, Gmail, Telegram, and LLM credentials, then:

```bash
docker compose up -d
```

**Option C – Edit via temporary container**

```bash
# Find volume mountpoint (Linux)
docker volume inspect nanobot_nanobot_data

# On Windows/Mac, use a temp container to edit:
docker compose run --rm -v nanobot_data:/data alpine sh -c "apk add --no-cache nano && nano /data/config.json"
# Or copy file out, edit locally, copy back with docker cp
```

Restart after changing config:

```bash
docker compose restart
```

---

## 3. Git (SSH) – path only, not in config

SSH for GitHub is configured only via the compose file and environment (no key path in `config.json`). The Docker image includes `openssh-client` so `GIT_SSH_COMMAND` works.

**Create key on host:**

```bash
mkdir -p keys
ssh-keygen -t ed25519 -f keys/nanobot_ed25519 -C "nanobot-agent" -N ""
```

**Add public key to GitHub:**

- Copy `keys/nanobot_ed25519.pub`
- GitHub → Settings → SSH and GPG keys → New SSH key (or use a deploy key per repo)

**Enable in docker-compose.yml:**

Uncomment these lines under `volumes` and `environment`:

```yaml
volumes:
  - nanobot_data:/root/.nanobot
  - ./keys/nanobot_ed25519:/root/.nanobot/keys/id_ed25519:ro

environment:
  - NANOBOT_AGENTS__DEFAULTS__WORKSPACE=/root/.nanobot/workspace
  - GIT_SSH_COMMAND=ssh -i /root/.nanobot/keys/id_ed25519 -o StrictHostKeyChecking=accept-new
```

**Restart:**

```bash
docker compose up -d
```

The agent can now `git clone`, `git push`, and open PRs via SSH.

---

## 4. Slack / Gmail / Telegram

Configure in `config.json` (inside the volume or your bind-mounted file):

- **Slack**: `channels.slack.enabled: true`, `botToken`, `appToken` (Socket Mode)
- **Gmail**: `channels.email.enabled: true`, IMAP/SMTP credentials, `fromAddress`, `allowFrom`
- **Telegram**: `channels.telegram.enabled: true`, `token`, `allowFrom` (your user ID)
- **LLM**: `providers.openrouter.apiKey` (or anthropic, openai, etc.)

See [LOCAL_SETUP.md](LOCAL_SETUP.md) for detailed channel setup.

---

## 5. Workspace and VS Code

**Default:** The agent’s workspace is `/root/.nanobot/workspace` inside the container, backed by the `nanobot_data` volume.

**Use the same repo as VS Code on the host:** Bind mount your project into the container:

In `docker-compose.yml`:

```yaml
volumes:
  - nanobot_data:/root/.nanobot
  - /path/on/host/my-react-app:/root/.nanobot/workspace:rw
```

Open `/path/on/host/my-react-app` in VS Code on the same machine. The agent and you edit the same files.

**Optional:** Set workspace in config via env (already set in compose):

```yaml
environment:
  - NANOBOT_AGENTS__DEFAULTS__WORKSPACE=/root/.nanobot/workspace
```

---

## 6. Start and verify

```bash
docker compose up -d
docker compose logs -f nanobot
```

You should see something like:

```
✓ Config: /root/.nanobot/config.json
✓ Workspace: /root/.nanobot/workspace
✓ Telegram: listening for messages
✓ Slack: listening for messages
✓ Heartbeat: every 30m
```

Send a message via Telegram or Slack to confirm the agent responds.

---

## 7. Useful commands

| Command | Description |
|--------|--------------|
| `docker compose up -d` | Start gateway in background |
| `docker compose down` | Stop and remove container (volume kept) |
| `docker compose logs -f nanobot` | Follow logs |
| `docker compose run --rm nanobot status` | Show status |
| `docker compose run --rm nanobot agent -m "Hello"` | One-off agent query |
| `docker compose run --rm nanobot cron list` | List scheduled jobs |

---

## 8. Resource limits

Default limits in `docker-compose.yml`: 4 CPUs, 8 GB RAM. Adjust under `deploy.resources.limits` if needed.

---

## 9. Summary

| What | Where | How |
|------|--------|-----|
| **Config (Slack, Gmail, LLM)** | `config.json` | In volume or bind-mounted file; edit on host |
| **Git (SSH)** | Not in config | Mount key + set `GIT_SSH_COMMAND` in compose |
| **Workspace** | `/root/.nanobot/workspace` | Default in volume; or bind mount your repo for VS Code |
| **Persistent data** | Volume `nanobot_data` | Config, workspace, memory, cron persist across restarts |

Your agent runs 24/7 in Docker with git (SSH), Slack, Gmail, and your code—ready to work like a colleague.
