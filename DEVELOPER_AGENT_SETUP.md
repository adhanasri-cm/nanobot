# Nanobot React/React Native Developer Agent - Local Setup

**Status**: ✅ Ready for local testing with Telegram/Slack

This document describes the complete setup of a Nanobot-based React/React Native developer colleague for local use.

## What's Been Set Up

### 1. Agent Bootstrap Files (Workspace)

Located in `workspace/`:

- **`AGENTS.md`** – Agent role, workflow (feature branches, lint/test/PR), 2026 React/RN best practices
- **`SOUL.md`** – Agent personality (developer colleague, pragmatic, focused)
- **`USER.md`** – User profile template (adjust timezone, preferences, tools)
- **`IDENTITY.md`** – Agent oath and boundaries (colleague, not committer)
- **`SYSTEM_PROMPT.md`** – Detailed system prompt with code examples for React/RN best practices
- **`TOOLS.md`** – (existing) Available tools
- **`HEARTBEAT.md`** – (existing) Periodic task management

### 2. Configuration Templates

- **`config.template.json`** – Template for local Nanobot config (LLM, Telegram, Slack)
- **`LOCAL_SETUP.md`** – Full step-by-step setup guide
- **`setup-local.sh`** – Bash setup script (macOS/Linux)
- **`setup-local.ps1`** – PowerShell setup script (Windows)

### 3. Current Config

Your config at `~/.nanobot/config.json` is ready. Next: add your API credentials.

---

## Quick Start (5 minutes)

### Step 1: Get API Credentials

**LLM Provider** (choose one):
- **OpenRouter** (recommended): https://openrouter.ai/keys
- **Anthropic (Claude)**: https://console.anthropic.com
- **OpenAI (GPT)**: https://platform.openai.com/api-keys
- **Others**: DeepSeek, Groq, Gemini, etc.

**Telegram Bot** (recommended for testing):
1. Open Telegram → Search `@BotFather`
2. Send `/newbot`, follow prompts
3. Copy bot token (format: `123456789:ABCdef...`)
4. Search `@userinfobot` → send any message → copy your user ID

**Slack** (optional):
- https://api.slack.com/apps → Create New App → Socket Mode
- Get bot token (`xoxb-...`) and app token (`xapp-...`)

### Step 2: Update Config

Edit `~/.nanobot/config.json`:

```json
{
  "agents": {
    "defaults": {
      "workspace": "~/.nanobot/workspace",
      "model": "anthropic/claude-opus-4-5"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_TELEGRAM_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  },
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-YOUR_KEY"
    }
  }
}
```

### Step 3: Start Gateway

```bash
# Windows (PowerShell)
.venv\Scripts\Activate.ps1
nanobot gateway

# macOS/Linux
source .venv/bin/activate
nanobot gateway
```

### Step 4: Send Message

Open Telegram, find your bot, and send:

```
Hello! I'm working on a React component. Can you help me write a Button component with TypeScript and Tailwind CSS?
```

The agent responds with code and explanation.

---

## Testing Scenarios

### Material Design 3 Usage

When asking for UI components, the agent will:
- Use [Material Design 3 guidelines](https://m3.material.io/)
- Suggest Material-UI (MUI) v5+ for React projects
- Apply Material 3 color tokens, typography scale, and spacing system
- Build accessible components by default
- Follow Material Design 3 motion and elevation principles

Example request:
```
Create a user profile card component using Material Design 3 and MUI.
Include: user avatar, name, email, and action buttons.
Use Material 3 color tokens and spacing.
```

### Test 1: Code Generation

**You send:**
```
Create a custom React hook that manages form state with validation errors.
Show TypeScript types and unit tests.
```

**Agent should:**
- Ask clarifying questions if needed
- Explain the approach
- Show hook code with types
- Show test examples
- If UI involved: suggest Material Design 3 components

### Test 2: Project Integration

Set workspace to a React project:

```json
{
  "agents": {
    "defaults": {
      "workspace": "/path/to/my-react-app"
    }
  }
}
```

**You send:**
```
Read the README and package.json. Then run `npm run lint` and summarize any issues.
```

**Agent should:**
- Read project files
- Run npm command
- Report linting issues with suggestions

### Test 3: Feature Branch Workflow

**You send:**
```
Create a feature to add a user profile page. 
Create a branch, write a React component using TypeScript, and open a PR.
```

**Agent should:**
- Create `feature/user-profile` branch
- Write component (atoms/molecules/organisms)
- Run lint/test
- Create PR with description

### Test 4: Cron & Heartbeat

**You send (via Telegram):**
```
Add a reminder to check test coverage every morning at 9 AM
```

**Agent should:**
- Add a cron job
- Update HEARTBEAT.md with periodic tasks

---

## Detailed Configuration

### Full Config Example

```json
{
  "agents": {
    "defaults": {
      "workspace": "~/.nanobot/workspace",
      "model": "anthropic/claude-opus-4-5",
      "maxTokens": 8192,
      "temperature": 0.7,
      "maxToolIterations": 20,
      "memoryWindow": 50
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "123456789:ABCdefGHIjklmnoPQRstuvWXYz",
      "allowFrom": ["987654321"],
      "proxy": null
    },
    "slack": {
      "enabled": false,
      "mode": "socket",
      "botToken": "xoxb-...",
      "appToken": "xapp-...",
      "userTokenReadOnly": true,
      "groupPolicy": "mention",
      "dm": {
        "enabled": true,
        "policy": "open"
      }
    }
  },
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-..."
    }
  },
  "gateway": {
    "host": "127.0.0.1",
    "port": 18790
  },
  "tools": {
    "exec": {
      "timeout": 60
    },
    "restrictToWorkspace": true
  }
}
```

### Customize Agent Behavior

Edit these files in `~/.nanobot/workspace/` to personalize:

**`USER.md`** – Your preferences:
```markdown
- **Timezone**: UTC (adjust as needed)
- **Communication Style**: Technical
- **Response Length**: Brief and concise
```

**`AGENTS.md`** – Modify workflow (already tailored for React/RN)

**`SYSTEM_PROMPT.md`** – Detailed practices (reference during development)

---

## CLI Commands

```bash
# One-off query
nanobot agent -m "Write a React hook for..."

# Interactive mode
nanobot agent

# Start gateway (for Telegram/Slack)
nanobot gateway

# Check status
nanobot status

# Scheduled jobs
nanobot cron add --name "test" --message "Run tests" --cron "0 9 * * *"
nanobot cron list
nanobot cron remove <job_id>
```

---

## File Locations

```
~/.nanobot/
├── config.json              # Runtime config (LLM, channels, tools)
└── workspace/               # Agent workspace (default)
    ├── AGENTS.md            # Agent role & workflow
    ├── SOUL.md              # Personality
    ├── USER.md              # Your profile
    ├── IDENTITY.md          # Agent oath
    ├── SYSTEM_PROMPT.md     # Best practices guide
    ├── TOOLS.md             # Available tools
    ├── HEARTBEAT.md         # Periodic tasks
    └── memory/
        ├── MEMORY.md        # Long-term facts
        └── HISTORY.md       # Event log (grep-searchable)
```

---

## Next Steps

1. **Get credentials**: LLM API key + Telegram bot token
2. **Edit config**: Update `~/.nanobot/config.json`
3. **Start gateway**: `nanobot gateway`
4. **Send test message**: Via Telegram
5. **Try scenarios**: Follow testing scenarios above
6. **Iterate**: Refine agent instructions in workspace files as needed

---

## Troubleshooting

### "ModuleNotFoundError: No module named 'nanobot'"

Activate venv and reinstall:

```bash
# Windows
.venv\Scripts\Activate.ps1
pip install -e .

# macOS/Linux
source .venv/bin/activate
pip install -e .
```

### "Telegram: bot was blocked by the user"

Ensure user ID is in `allowFrom`:

```json
{
  "channels": {
    "telegram": {
      "allowFrom": ["YOUR_USER_ID"]
    }
  }
}
```

### Agent doesn't respond

Check logs:

```bash
nanobot gateway  # Watch for error messages
```

Common issues:
- LLM API key is invalid/expired
- Bot token is wrong
- Network connectivity

### "restrictToWorkspace: true" error

If agent can't read files:

```json
{
  "tools": {
    "restrictToWorkspace": true
  }
}
```

Set workspace correctly in config (default: `~/.nanobot/workspace/`).

---

## Security & Best Practices

1. **Never commit credentials**: Store API keys in config, not Git
2. **Use allowFrom lists**: Restrict who can interact
3. **Sandbox workspace**: `restrictToWorkspace: true` prevents file escape
4. **Separate instances**: Create separate configs for different projects/contexts

---

## What's Next?

### Local Testing (Now)
- Send test messages via Telegram/Slack
- Try code generation, file ops, shell commands
- Refine agent instructions in workspace files

### Docker Deployment (Later)
- Use docker-compose for consistent environment
- Mount workspace for persistence
- Use for 24/7 uptime

### Production (Future)
- Deploy on Hetzner VPS
- Set up GitHub App for PRs
- Configure email for async updates
- Add more channels (Discord, Feishu, etc.)

---

## Support

For detailed information, see:
- **LOCAL_SETUP.md** – Step-by-step setup with screenshots
- **SYSTEM_PROMPT.md** – Detailed React/RN best practices
- **README.md** – Official Nanobot documentation

**Status**: Ready to test! Start with Step 1 above. 🚀
