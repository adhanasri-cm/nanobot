# Nanobot React Developer Agent - Setup Summary

## What's Ready

Your Nanobot-based **React/React Native Developer Agent** is ready for local testing with Telegram and Slack. The agent is configured to follow **Material Design 3** for all UI development. All agent instructions, configuration templates, and setup guides have been created.

---

## 📁 Files Created

### Setup & Documentation

| File | Purpose |
|------|---------|
| **DEVELOPER_AGENT_SETUP.md** | Complete setup guide with configuration examples |
| **LOCAL_SETUP.md** | Step-by-step setup with Telegram/Slack tutorials |
| **QUICK_TEST_CHECKLIST.md** | Testing checklist to verify everything works |
| **config.template.json** | Config template (copy to `~/.nanobot/config.json`) |
| **setup-local.ps1** | Automated setup script (Windows PowerShell) |
| **setup-local.sh** | Automated setup script (macOS/Linux bash) |

### Agent Instructions (Workspace)

Updated files in `workspace/`:

| File | Content |
|------|---------|
| **AGENTS.md** | Agent role, React/RN workflow, best practices |
| **SOUL.md** | Personality (colleague, pragmatic, focused) |
| **USER.md** | Your profile (adjust timezone, preferences) |
| **IDENTITY.md** | Agent oath (colleague, not committer) |
| **SYSTEM_PROMPT.md** | Detailed React/RN 2026 best practices with examples |
| **TOOLS.md** | Available tools (pre-existing) |
| **HEARTBEAT.md** | Periodic task management (pre-existing) |

---

## 🚀 Quick Start (Choose One)

### Option A: Automated Setup (Recommended)

**Windows:**
```powershell
.venv\Scripts\Activate.ps1
.\setup-local.ps1
```

**macOS/Linux:**
```bash
source .venv/bin/activate
bash setup-local.sh
```

Then follow the prompts to add your API credentials.

### Option B: Manual Setup (5 minutes)

1. **Get credentials** (see below)
2. **Edit** `~/.nanobot/config.json` with your API keys and Telegram token
3. **Start** `nanobot gateway`
4. **Test** by sending a message to your Telegram bot

### Option C: Detailed Guide

Follow the step-by-step instructions in:
- **DEVELOPER_AGENT_SETUP.md** – Quick start + examples
- **LOCAL_SETUP.md** – Full tutorial with screenshots

---

## 🔑 Get Credentials (10 min)

### 1. LLM Provider (Required)

Choose one:

- **OpenRouter** (recommended): https://openrouter.ai/keys → copy `sk-or-v1-...`
- **Anthropic**: https://console.anthropic.com → copy `sk-ant-...`
- **OpenAI**: https://platform.openai.com/api-keys → copy `sk-proj-...`

### 2. Telegram Bot (Recommended for Testing)

1. Open Telegram → Search `@BotFather`
2. Send `/newbot` → follow prompts → copy token
3. Search `@userinfobot` → send any message → copy your user ID

### 3. Slack (Optional)

1. Go to https://api.slack.com/apps → Create New App → Socket Mode
2. Generate/copy app token (`xapp-...`)
3. Add bot scopes: `chat:write`, `app_mentions:read`
4. Install app → copy bot token (`xoxb-...`)

---

## ⚙️ Configure

Edit `~/.nanobot/config.json`:

```json
{
  "agents": {
    "defaults": {
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

Or copy `config.template.json` and edit it.

---

## ▶️ Start

```bash
# Activate virtual environment
.venv\Scripts\Activate.ps1          # Windows
# or
source .venv/bin/activate            # macOS/Linux

# Start the gateway
nanobot gateway
```

Expected output:
```
✓ Config: ~/.nanobot/config.json
✓ Workspace: ~/.nanobot/workspace
✓ Model: anthropic/claude-opus-4-5
✓ Telegram: listening for messages
✓ Heartbeat: every 30m
```

---

## 📱 Test

### Via Telegram

Open Telegram, find your bot, send:

```
Hello! Can you help me create a React component for displaying user information?
```

The agent responds with code and explanation.

### Via CLI

```bash
nanobot agent -m "Write a TypeScript function that validates an email address"
```

### Interactive

```bash
nanobot agent

# Now type multiple messages and have a conversation
# Exit with: exit, quit, or Ctrl+D
```

---

## ✅ Verification

Follow **QUICK_TEST_CHECKLIST.md** to verify:

- Agent responds via Telegram/CLI
- File operations work (read/write)
- Shell commands execute
- Code follows React 2026 practices
- Memory persists between conversations

---

## 📚 Documentation

| Document | When to Read |
|----------|--------------|
| **DEVELOPER_AGENT_SETUP.md** | Overview + config examples |
| **LOCAL_SETUP.md** | Full step-by-step guide |
| **SYSTEM_PROMPT.md** | React/RN best practices (reference) |
| **QUICK_TEST_CHECKLIST.md** | Verify everything works |
| **AGENTS.md** | Agent role/workflow (in workspace) |
| **config.template.json** | Config template |

---

## 🎯 Next Steps

### 1. Quick Test (Now)
- Add credentials
- Start gateway
- Send test message to Telegram

### 2. Bug Fixing

Your agent can also systematically fix bugs:

```
There's a bug: the form data doesn't update when the user ID changes.
The useEffect seems to run only once.
```

The agent will:
1. Ask clarifying questions
2. Read the code to understand the issue
3. Write a failing test that demonstrates the bug
4. Fix with minimal changes (add missing dependency)
5. Verify all tests pass
6. Open a PR with explanation

See **BUG_FIXING_GUIDE.md** for debugging strategies and common bug patterns.

### 3. Material Design 3 Components

Ask the agent to create UI components using Material Design 3:

```
Create a login form using Material Design 3 and MUI.
Include email, password fields, and submit button.
Use Material 3 colors and spacing system.
```

See **MATERIAL_DESIGN_3_GUIDE.md** for all design tokens, components, and examples.

### 4. Use with Your Project
```json
{
  "agents": {
    "defaults": {
      "workspace": "/path/to/my-react-app"
    }
  }
}
```

Then ask agent to:
- Read README and package.json
- Run `npm run lint`
- Help with Material Design 3 components
- Fix bugs in your code
- Refactor existing UI to Material Design 3

### 5. Advanced Setup (Later)
- Add Slack for team collaboration
- Schedule cron jobs for testing
- Deploy to Docker for 24/7 uptime
- Add GitHub App for automated PRs

---

## 📋 File Locations

```
~/.nanobot/
├── config.json              # Edit this with your credentials
└── workspace/               # Agent instructions
    ├── AGENTS.md            # Agent role (UPDATED)
    ├── SOUL.md              # Personality (UPDATED)
    ├── USER.md              # Your profile (UPDATED)
    ├── IDENTITY.md          # Agent oath (NEW)
    ├── SYSTEM_PROMPT.md     # Best practices (NEW)
    ├── TOOLS.md
    ├── HEARTBEAT.md
    └── memory/
        ├── MEMORY.md        # Long-term facts
        └── HISTORY.md       # Event log

c:\projects\nanobot\          # Repo root
├── DEVELOPER_AGENT_SETUP.md  # This setup (NEW)
├── LOCAL_SETUP.md            # Detailed guide (NEW)
├── QUICK_TEST_CHECKLIST.md   # Testing checklist (NEW)
├── config.template.json      # Config template (NEW)
├── setup-local.ps1           # Windows setup script (NEW)
├── setup-local.sh            # Linux/macOS setup script (NEW)
└── workspace/                # Agent workspace (UPDATED)
```

---

## 🔒 Security

- **Never commit credentials** – store in `~/.nanobot/config.json` (Git-ignored)
- **Use allowFrom** – restrict who can interact with agent
- **Sandbox enabled** – `restrictToWorkspace: true` prevents file escape
- **Separate configs** – create different configs for different projects

---

## 🆘 Troubleshooting

**Agent doesn't respond:**
- Check logs: `nanobot gateway`
- Verify API key in config
- Verify bot token and user ID for Telegram
- Check network connectivity

**"ModuleNotFoundError":**
```bash
.venv\Scripts\Activate.ps1   # Activate venv
pip install -e .              # Reinstall
```

**Can't read project files:**
- Ensure `workspace` in config points to project
- Check `restrictToWorkspace: true` – may need to adjust workspace path

---

## 📞 Support

Refer to these for help:

1. **DEVELOPER_AGENT_SETUP.md** – Configuration guide
2. **LOCAL_SETUP.md** – Detailed tutorials
3. **README.md** – Official Nanobot docs
4. **GitHub** – https://github.com/HKUDS/nanobot

---

## 🎉 Ready?

1. Get credentials (10 min)
2. Edit `~/.nanobot/config.json` (2 min)
3. Run `nanobot gateway` (instant)
4. Send message to Telegram (1 sec)

**Your React/React Native Developer Agent is ready! Start with DEVELOPER_AGENT_SETUP.md.** 🚀
