---
name: tech-digest
description: Generates a weekly tech digest of news, releases, and announcements relevant to the user's development stack (AWS, Python, Neovim, AI coding tools, terminal tools). Use this skill whenever the user asks to generate a digest, run the weekly digest, fetch tech news, or says anything like "run the digest", "what's new in tech this week", "generate my weekly update", or "check for updates". Trigger even if the user doesn't say "digest" explicitly — if they're asking for a curated update of recent tech news across their stack, this skill applies.
---

## What this skill does

Generates a structured tech digest saved as an Obsidian note. It covers the period since the last digest was created, up to today.

## Step 1: Determine the date range

1. List the files in `~/personal/obsidian/Work/digest/` and identify the most recent one by filename (files are named `YYYY-MM-DD.md`)
2. The **last digest date** is the date in that filename — this is your `START_DATE`
3. The **new digest** covers from `START_DATE` to today (`currentDate` in context)
4. Pass `START_DATE` and today's date explicitly to each search agent so they constrain their searches to that window

The gap may be longer than a week — search as far back as `START_DATE` regardless.

## Step 2: Run 5 parallel search agents

Launch all five simultaneously, passing them both `START_DATE` and today's date. Each returns structured findings with source URLs — they don't need to write files.

### Agent 1: AWS Serverless & Data Engineering (use Sonnet)

Search for news and announcements **since `START_DATE`** on:
- AWS Lambda, SAM CLI, CloudFormation, Step Functions, EventBridge, API Gateway
- DynamoDB, S3, SQS, SNS
- AWS Glue, Athena, Redshift, Kinesis, Lake Formation, RDS
- SageMaker, SageMaker Unified Studio
- Lakehouse services: Lake Formation, Redshift Spectrum, Apache Iceberg/Hudi table formats, EMR, Data Zone
- AWS blog posts and official announcements at aws.amazon.com/blogs/aws/ and aws.amazon.com/about-aws/whats-new/

For major announcements, do a follow-up search to find the blog post or technical deep-dive. Return findings with source URLs.

### Agent 2: Programming Languages & Core Tools (use Haiku)

Search for releases, PEPs, and ecosystem news **since `START_DATE`** on:
- Python (new versions, PEPs accepted/rejected, major library releases, ecosystem events like PyCon)
- TypeScript and Node.js
- Lua and Nim
- uv, ruff, pylint, cargo/Rust toolchain
- PostgreSQL, SQL Server

Return findings with source URLs.

### Agent 3: Neovim & Editor Ecosystem (use Haiku)

Search for releases and updates **since `START_DATE`** on:
- Neovim (new releases, milestones, nightly builds)
- treesitter, LSP protocol updates
- lazy.nvim, telescope, nvim-cmp, conform.nvim, nvim-lint
- CodeCompanion.nvim
- Alacritty, tmux, oh-my-zsh, fzf, ripgrep, fd, bat

Return findings with source URLs.

### Agent 4: AI Coding Tools (use Haiku)

Search for releases and news **since `START_DATE`** on:
- Anthropic Claude (API changes, new models, Claude Code CLI releases on github.com/anthropics/claude-code/releases)
- GitHub Copilot (CLI releases, agent updates, product changes)
- Pi coding agent (`mariozechner/pi-mono` on GitHub) and oh-my-pi
- OpenCode and oh-my-opencode
- Google Gemini (API, model releases, product updates)

Return findings with source URLs.

### Agent 5: Deep-Dive & Supplementary (use Sonnet)

After the other agents return (or run in parallel if timing allows). Search **since `START_DATE`**:
- Follow up on any large announcements surfaced by agents 1–4 with searches for blog posts, migration guides, or community reaction
- Docker, Git, Linux (Arch, Ubuntu/WSL2) major updates
- Any cross-cutting themes (e.g., acquisitions, security advisories, major deprecations)

Return findings with source URLs.

## Step 3: Compile the digest

Distill all agent findings into a structured Obsidian note using this exact template:

```markdown
---
id: YYYY-MM-DD
aliases: []
tags: []
---
# Digest — [START_DATE month+day] – [today month+day, Year]

## AWS & Cloud

### Serverless & Infrastructure
[items]

### SageMaker & Data Platform
[items]

### Lakehouse & Analytics
[items]

### Other AWS
[items]

---

## AI Coding Tools

### Anthropic Claude
[items]

### GitHub Copilot
[items]

### Google Gemini
[items]

### Pi & OpenCode
[items]

---

## Programming Languages

### Python
[items]

### TypeScript
[items]

### Rust
[items]

### PostgreSQL
[items]

---

## Neovim & Editor Ecosystem
[items]

---

## Terminal & CLI Tools
[items]

---

## Key Takeaways

1. **[Most important story]** — [2-3 sentence explanation of why it matters]
2. [4-5 more key takeaways ranked by significance]
```

**Formatting rules:**
- Each item: bold title + one-line summary + source link in brackets
- Major items (significant releases, acquisitions, security advisories): add 2–3 sentences of detail below the summary line
- Omit subsections that have no content — don't leave empty headers
- Key Takeaways: 4–6 items, ranked by significance, each with a 1–2 sentence explanation of *why it matters* to this stack

## Step 4: Write the output

Write the note to:
```
~/personal/obsidian/Work/digest/YYYY-MM-DD.md
```

Where `YYYY-MM-DD` is today's date. Create the directory if it doesn't exist.

## Step 5: Verify

- Confirm the file was written and report its path
- Briefly summarize (2–3 sentences) what the most significant items were
