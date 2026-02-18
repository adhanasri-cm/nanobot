# Nanobot React Agent - Quick Test Checklist

Use this checklist to verify your local Nanobot setup is working correctly.

## ✅ Pre-Flight Checks

- [ ] Python 3.11+ installed: `python --version`
- [ ] Git installed: `git --version`
- [ ] Nanobot installed: `pip install -e .` (from repo root)
- [ ] Workspace files created: `~/.nanobot/workspace/AGENTS.md` exists
- [ ] Config template available: `./config.template.json` in repo

---

## ✅ Step 1: Get Credentials (10 min)

### LLM Provider
- [ ] Choose provider (OpenRouter recommended)
- [ ] Create/get API key
- [ ] Copy API key to clipboard

### Telegram Bot (Recommended)
- [ ] Open Telegram
- [ ] Search `@BotFather`
- [ ] Send `/newbot`
- [ ] Copy bot token
- [ ] Search `@userinfobot`
- [ ] Send any message
- [ ] Copy your user ID

### Slack (Optional)
- [ ] Go to https://api.slack.com/apps
- [ ] Create new app or select existing
- [ ] Enable Socket Mode
- [ ] Generate/copy app token (`xapp-...`)
- [ ] Go to OAuth & Permissions
- [ ] Add bot scopes: chat:write, app_mentions:read
- [ ] Install app to workspace
- [ ] Copy bot token (`xoxb-...`)

---

## ✅ Step 2: Configure (5 min)

- [ ] Open `~/.nanobot/config.json` (or copy from `config.template.json`)
- [ ] Set LLM provider API key:
  ```json
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-YOUR_KEY"
    }
  }
  ```
- [ ] Set Telegram credentials:
  ```json
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  }
  ```
- [ ] (Optional) Set Slack credentials
- [ ] Save config

---

## ✅ Step 3: Start Gateway (2 min)

```bash
# Activate venv (if not already)
.venv\Scripts\Activate.ps1  # Windows
# or
source .venv/bin/activate    # macOS/Linux

# Start gateway
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

- [ ] No errors in startup
- [ ] "Telegram: listening for messages" appears

---

## ✅ Step 4: Send First Message (2 min)

### Via Telegram

1. Open Telegram
2. Search for the bot name you created
3. Click "Start" or send any message
4. Send this test message:
   ```
   Hello! Are you ready to help me with React?
   ```

**Expected response**: Agent greets you and asks what React task you'd like help with.

- [ ] Received response from bot
- [ ] Response is helpful and in character

### Via CLI (Alternative)

```bash
nanobot agent -m "Hello! Are you ready to help me with React?"
```

- [ ] Received response in terminal

---

## ✅ Step 5: Test Capabilities

### Test 5a: Code Generation

**Send:**
```
Create a Material Design 3 user card component using MUI.
Include user avatar, name, email, and action buttons.
Show TypeScript types and styling with Material 3 tokens.
```

**Check:**
- [ ] Agent explains approach
- [ ] Component uses Material-UI components
- [ ] Material 3 color tokens are applied
- [ ] Includes TypeScript types
- [ ] Code follows 2026 React practices (functional, hooks)
- [ ] Material Design 3 styling is correct

**Alternative (non-Material test):**
```
Write a React hook called useCounter that tracks a count with increment/decrement.
Include TypeScript types and a Jest unit test.
```

### Test 5b: File Operations

**Send:**
```
Create a file at `src/hooks/useCounter.ts` with the above hook code.
Then read it back and verify.
```

**Check:**
- [ ] Agent creates file in workspace
- [ ] Agent reads file back
- [ ] Content matches what was written

### Test 5c: Shell Commands

**Send (if in a React project):**
```
Run `npm run lint` and tell me if there are any errors.
```

**Check:**
- [ ] Agent runs npm command
- [ ] Reports linting results (or "no errors found")

### Test 5d: Bug Fixing

**Send:**
```
There's a bug: when I change the user ID, the profile data doesn't update.
It still shows the old user's information.
The useEffect fetches data with userId but seems to run only once.
```

**Check:**
- [ ] Agent asks clarifying questions
- [ ] Agent reads the relevant component code
- [ ] Agent identifies the root cause (missing dependency)
- [ ] Agent writes a failing test first
- [ ] Agent fixes with minimal changes (adds userId to deps)
- [ ] Agent verifies with tests and lint

### Test 5e: Git/GitHub

**Send:**
```
If we create a feature for a button component, what would be a good branch name and PR title?
Suggest a conventional commit format.
```

**Check:**
- [ ] Agent suggests proper branch naming (feature/...)
- [ ] PR title follows conventional commits (feat: ...)
- [ ] Explanation is clear

### Test 5f: Memory & Learning

**Send:**
```
Remember: I prefer Tailwind CSS for styling and Jest for testing.
Confirm this is saved.
```

**Check:**
- [ ] Agent confirms memory update
- [ ] Future responses mention Tailwind/Jest preferences
- [ ] Check `~/.nanobot/workspace/memory/MEMORY.md` has the entry

---

## ✅ Step 6: Advanced Tests (Optional)

### Scheduled Task

**Send:**
```
Schedule a reminder to review React Hooks every morning at 9 AM using cron.
```

**Check:**
- [ ] Agent creates cron job
- [ ] `nanobot cron list` shows the job
- [ ] Job name appears (e.g., "review-react-hooks")

### Heartbeat Task

**Send:**
```
Add a periodic task to check TypeScript compilation daily.
```

**Check:**
- [ ] Agent updates `~/.nanobot/workspace/HEARTBEAT.md`
- [ ] Task appears in file with format: `- [ ] Check TypeScript compilation`

### Interactive Mode

**Run:**
```bash
nanobot agent
```

**Send messages:**
```
Let's build a React component for a user card.
What would be good props?

How would we handle accessibility?

Can you write the component code?
```

**Check:**
- [ ] Multi-turn conversation works
- [ ] Agent remembers context across messages
- [ ] Code suggestions improve with each interaction

---

## ✅ Success Criteria

Mark this complete when:

- [x] Nanobot responds to Telegram/CLI messages
- [x] Agent explains React/TypeScript code clearly
- [x] File operations work (read/write)
- [x] Shell commands execute
- [x] Agent memory persists between conversations
- [x] Responses follow 2026 React best practices (functional, hooks, TypeScript)

---

## 🎉 Congratulations!

Your local Nanobot React/React Native Developer Agent is ready!

### What's Next?

1. **Point to your project**: Set `workspace` in config to your React project path
2. **Test with real code**: Ask agent to read/refactor/test your actual code
3. **Iterate on prompts**: Update `AGENTS.md`, `SOUL.md`, `SYSTEM_PROMPT.md` to fine-tune behavior
4. **Add Slack**: Enable Slack channel for multi-platform access
5. **Docker**: When ready, use docker-compose for 24/7 uptime

### Useful Files

- **DEVELOPER_AGENT_SETUP.md** – Full guide (this document links here)
- **LOCAL_SETUP.md** – Step-by-step setup instructions
- **SYSTEM_PROMPT.md** – React/RN best practices (reference for agent)
- **AGENTS.md** – Agent role definition (in workspace)

### Key Commands

```bash
# Test quick queries
nanobot agent -m "Your question"

# Start gateway for Telegram/Slack
nanobot gateway

# Check status
nanobot status

# View scheduled jobs
nanobot cron list

# Interactive mode
nanobot agent
```

---

**Happy coding! Your AI colleague is ready to help.** 🚀
