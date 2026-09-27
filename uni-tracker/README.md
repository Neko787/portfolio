# Uni Tracker

A private automation that logs in to my university portal, scrapes announcements,
fees, penalties, PDFs and videos, summarizes them with AI, shows them on a
dashboard, and sends a Telegram digest 3 times a day.

It runs entirely in Docker on my own computer. This folder is separate from the
portfolio website.

## Build plan

| Step | What | Status |
| --- | --- | --- |
| 1 | Docker stack: **n8n** (automation) + **Ollama** (local AI) + Telegram check | ✅ this step |
| 2 | Scraper service: logs in to the portal, collects new items, safety-checks links | next |
| 3 | n8n workflows: 07:00 / 13:00 / 19:00 scrape → AI summary → Telegram digest | |
| 4 | Approvals: ask me on Telegram before opening any PDF, download or video | |
| 5 | Dashboard landing page | |

---

## Step 1 - get the Docker stack running

### 1.1 What you need

- **Docker Desktop** (Windows / Mac) or **Docker Engine + Compose plugin** (Linux). Check with:
  ```
  docker compose version
  ```
- **Git**
- About **10 GB free disk** and **8 GB+ RAM** for the default AI model
  (or pick the smaller model in step 1.2).

> Already running n8n in Docker? It also uses port 5678. Stop the old container first
> (`docker stop <name>`) or change the port line in `docker-compose.yml` to `"5679:5678"`.

### 1.2 Get the code and create your `.env`

```
git clone https://github.com/Neko787/portfolio.git
cd portfolio
git checkout claude/university-scraper-n8n-k96tkd
cd uni-tracker
```

If you already have the repo on your computer, run `git fetch` and then
`git checkout claude/university-scraper-n8n-k96tkd` inside it instead of cloning.

Copy the example settings file:

- Mac / Linux: `cp .env.example .env`
- Windows (PowerShell): `copy .env.example .env`

Open `.env` in any text editor and set `TZ` to your timezone. Leave the Telegram lines
empty for now; step 1.3 fills them in.

### 1.3 Create your Telegram bot

1. In Telegram, open **@BotFather**, send `/newbot`, and pick a name and username.
   BotFather replies with a token like `123456789:AAH...`. Put it in `.env` as `TELEGRAM_BOT_TOKEN`.
2. Open a chat with your new bot and press **Start**.
3. In a browser, open (with your token pasted in):
   `https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates`
   Find `"chat":{"id":123456789` and put that number in `.env` as `TELEGRAM_CHAT_ID`.

### 1.4 Start everything

```
docker compose up -d
```

The first start downloads the images and the AI model (several GB), so it can take a while.
Watch the model download with:

```
docker compose logs -f ollama-pull
```

It's done when that container exits with `success`. Check that everything is running:

```
docker compose ps
```

You should see `n8n` and `ollama` running. `ollama-pull` shows as exited, which is expected
because it only runs once.

### 1.5 Open n8n and run the setup check

1. Open **http://localhost:5678** and create your n8n owner account. It stays local on your computer.
2. Import the test workflow, either:
   - in n8n: **Create workflow → ⋯ menu → Import from file…** and pick
     `n8n/workflows/00-setup-check.json`, **or**
   - from the terminal:
     ```
     docker compose exec n8n n8n import:workflow --input=/workflows/00-setup-check.json
     ```
     then refresh n8n.
3. Open **00 - Setup check (Ollama + Telegram)** and click **Execute workflow**.

You should get a Telegram message like:

> ✅ n8n + Ollama (qwen2.5:7b) are working.
>
> Your university tracker setup is up and running!

The first run can take a minute while Ollama loads the model into memory.

### If something goes wrong

| Symptom | Fix |
| --- | --- |
| `Ask local AI` fails with *model not found* | The model is still downloading. Check `docker compose logs ollama-pull` |
| `Ask local AI` times out | Your computer may be short on RAM. Set `OLLAMA_MODEL=llama3.2:3b` in `.env`, then `docker compose up -d` |
| `Send to my Telegram` fails with *401 Unauthorized* | Wrong `TELEGRAM_BOT_TOKEN` |
| `Send to my Telegram` fails with *chat not found* | Wrong `TELEGRAM_CHAT_ID`, or you haven't pressed **Start** in the bot chat |
| Changed `.env` but nothing changed | Run `docker compose up -d` again. It recreates the containers with the new values |
| n8n page doesn't open | `docker compose logs n8n` shows why |

## Everyday commands

```
docker compose up -d         # start / apply .env changes
docker compose ps            # status
docker compose logs -f n8n   # n8n logs
docker compose down          # stop (workflows and AI model stay saved in Docker volumes)
```
