# Local Nanobot Developer Agent Setup

This guide sets up Nanobot as a React/React Native developer colleague on your local machine, connected via Telegram and/or Slack.

## Prerequisites

- **Python** 3.11+ (check: `python --version`)
- **Git** (for version control)
- **Node.js & npm** (if testing with a React project)
- **API credentials**:
  - [Telegram Bot Token](https://core.telegram.org/bots#6-botfather) (get from @BotFather on Telegram)
  - [Slack Bot Tokens](https://api.slack.com/apps) (optional; for Slack integration)
  - [LLM API Key](https://openrouter.ai/keys) (OpenRouter recommended; or Anthropic, OpenAI, etc.)

## Step 1: Install Nanobot

Clone and install from source:

```bash
cd /path/to/nanobot
pip install -e .
```

Verify installation:

```bash
nanobot --version
nanobot status
```

You should see Nanobot version and status (gateway may show errors if not configured yet).

## Step 2: Configure the LLM Provider

Edit `~/.nanobot/config.json` and set your LLM provider. Examples:

### Option A: OpenRouter (recommended, global access)

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-YOUR_API_KEY_HERE"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5"
    }
  }
}
```

Get API key: https://openrouter.ai/keys

### Option B: Anthropic (Claude direct)

```json
{
  "providers": {
    "anthropic": {
      "apiKey": "sk-ant-YOUR_API_KEY_HERE"
    }
  },
  "agents": {
    "defaults": {
      "model": "claude-opus-4-5"
    }
  }
}
```

Get API key: https://console.anthropic.com

### Option C: OpenAI (GPT)

```json
{
  "providers": {
    "openai": {
      "apiKey": "sk-proj-YOUR_API_KEY_HERE"
    }
  },
  "agents": {
    "defaults": {
      "model": "gpt-4"
    }
  }
}
```

Get API key: https://platform.openai.com/account/api-keys

## Step 3: Configure Telegram (Recommended for Testing)

### 3a. Create a Telegram Bot

1. Open Telegram and search for `@BotFather`
2. Send `/newbot`
3. Follow the prompts (name your bot, e.g., "my-nanobot")
4. Copy the bot token (format: `123456789:ABCdefGHIjklmnoPQRstuvWXYz`)

### 3b. Get Your Telegram User ID

1. Search for `@userinfobot` in Telegram
2. Send any message; it will reply with your user ID
3. Copy this ID (a number, e.g., `987654321`)

### 3c. Update Config

Edit `~/.nanobot/config.json`:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "123456789:ABCdefGHIjklmnoPQRstuvWXYz",
      "allowFrom": ["987654321"],
      "proxy": null
    }
  }
}
```

### 3d. Test

Start the gateway:

```bash
nanobot gateway
```

You should see in logs: `Telegram: listening for messages`

Open your bot in Telegram (search for the bot name you created) and send a message. The agent should respond!

## Step 4: Configure Slack (Optional)

### 4a. Create a Slack Bot

1. Go to https://api.slack.com/apps
2. Click "Create New App" → "From scratch"
3. Choose a name (e.g., "nanobot") and workspace
4. Navigate to **Socket Mode** → Toggle ON → Generate an **App-Level Token** (xapp-...) with `connections:write` scope
5. Copy the token

### 4b. Enable Permissions

1. Go to **OAuth & Permissions**
2. Add bot scopes: `chat:write`, `reactions:write`, `app_mentions:read`
3. **Install App** to workspace → authorize
4. Copy **Bot Token** (xoxb-...)

### 4c. Subscribe to Events

1. Go to **Event Subscriptions** → Toggle ON
2. Subscribe to bot events: `message.im`, `message.channels`, `app_mention`
3. Save changes

### 4d. Enable Message Tab

1. Go to **App Home**
2. Scroll to **Show Tabs** → Enable **Messages Tab**
3. Check "Allow users to send Slash commands and messages from the messages tab"

### 4e. Update Config

Edit `~/.nanobot/config.json`:

```json
{
  "channels": {
    "slack": {
      "enabled": true,
      "mode": "socket",
      "botToken": "xoxb-YOUR_BOT_TOKEN",
      "appToken": "xapp-YOUR_APP_LEVEL_TOKEN",
      "userTokenReadOnly": true,
      "groupPolicy": "mention",
      "groupAllowFrom": [],
      "dm": {
        "enabled": true,
        "policy": "open",
        "allowFrom": []
      }
    }
  }
}
```

### 4f. Test

Start the gateway:

```bash
nanobot gateway
```

DM your bot in Slack (search for the bot name) and send a message.

## Step 5: Verify Everything

Full config should look like:

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
      "token": "YOUR_TELEGRAM_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"],
      "proxy": null
    },
    "slack": {
      "enabled": true,
      "mode": "socket",
      "botToken": "xoxb-YOUR_BOT_TOKEN",
      "appToken": "xapp-YOUR_APP_LEVEL_TOKEN",
      "userTokenReadOnly": true,
      "groupPolicy": "mention",
      "groupAllowFrom": [],
      "dm": {
        "enabled": true,
        "policy": "open",
        "allowFrom": []
      }
    }
  },
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-YOUR_OPENROUTER_KEY"
    }
  },
  "gateway": {
    "host": "127.0.0.1",
    "port": 18790
  },
  "tools": {
    "web": {
      "search": {
        "apiKey": "",
        "maxResults": 5
      }
    },
    "exec": {
      "timeout": 60
    },
    "restrictToWorkspace": true
  }
}
```

## Step 6: Start the Gateway

```bash
nanobot gateway
```

Expected output:

```
✓ Config: ~/.nanobot/config.json
✓ Workspace: ~/.nanobot/workspace
✓ Model: anthropic/claude-opus-4-5
✓ Telegram: listening for messages
✓ Slack: listening for messages
✓ Heartbeat: every 30m
```

The gateway will listen on `http://127.0.0.1:18790` (for webhooks if you add them later).

## Step 7: Test the Agent

### Via Telegram

Send a message to your bot:

```
Hello, I'm working on a React component. Can you help me write a TypeScript Button component using Tailwind CSS?
```

The agent should respond with code and explanation.

### Via CLI (for quick testing)

```bash
nanobot agent -m "Create a React hook for local storage"
```

### Interactive Mode

```bash
nanobot agent
```

Type your message and press Enter. Exit with `exit`, `quit`, or `Ctrl+D`.

## Step 8: Test with a React Project

If you have a React project, configure the workspace:

Edit `~/.nanobot/config.json`:

```json
{
  "agents": {
    "defaults": {
      "workspace": "/path/to/your/react-project"
    }
  }
}
```

Then ask the agent:

```
Read the README and package.json. What's this project about? Then run `npm run lint` and report any issues.
```

The agent should:
1. Read files from the project
2. Run npm commands
3. Provide feedback

## Troubleshooting

### "No module named nanobot"

Make sure you installed Nanobot:

```bash
pip install -e .
```

### Telegram: "Forbidden: bot was blocked by the user"

Your bot doesn't have permission. Make sure your user ID is in `allowFrom`:

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

Check the logs for errors:

```bash
nanobot gateway --logs
```

Common issues:
- LLM API key is invalid or expired
- Bot token is invalid
- Network connectivity issues

### Import errors on Windows

If you see `ModuleNotFoundError`, ensure Python environment is activated:

```bash
.venv\Scripts\activate  # On Windows
# or
source .venv/bin/activate  # On macOS/Linux
```

## Next Steps

1. **Create feature branches**: Ask the agent to work on tasks
2. **Test with your React project**: Point the workspace to your project
3. **Use Telegram for async feedback**: Send tasks via Telegram, get responses
4. **Scale to Docker**: Once local setup is working, use docker-compose for consistent environment

## File Locations

- **Config**: `~/.nanobot/config.json`
- **Workspace**: `~/.nanobot/workspace/` (default, or custom via config)
- **Bootstrap files** (agent instructions):
  - `AGENTS.md` — agent role and workflow
  - `SOUL.md` — personality and values
  - `USER.md` — user profile
  - `SYSTEM_PROMPT.md` — detailed best practices
  - `TOOLS.md` — available tools
  - `HEARTBEAT.md` — periodic tasks
- **Memory**: `memory/MEMORY.md` (long-term facts) and `memory/HISTORY.md` (event log)

## Security Notes

- **Never commit credentials**: Store API keys in config, not Git
- **Use allowFrom lists**: Restrict who can interact with the agent
- **Sandbox the workspace**: Set `tools.restrictToWorkspace: true` (default)

---

**Ready?** Start the gateway and send your first message via Telegram! 🚀
