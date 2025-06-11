# 🧰 Foundry

> Personal Cloud/DevOps macOS Bootstrap Environment
> Built for engineers who live in the terminal — minimal, secure, and fast to rebuild.
> This project is continuously refined to reflect the principles below — staying aligned with modern DevOps and internal developer platform (IDP) practices.

![macOS](https://img.shields.io/badge/os-macOS%20(Apple%20Silicon)-blue?style=flat-square&logo=apple)
![Terminal First](https://img.shields.io/badge/terminal-first-lightgrey?style=flat-square&logo=gnubash)
![Automation](https://img.shields.io/badge/restore-fully--automated-success?style=flat-square&logo=githubactions)
![Dotfile Managed](https://img.shields.io/badge/dotfiles-managed%20by%20yadm-9cf?style=flat-square&logo=git)
![Cloud Ready](https://img.shields.io/badge/cloud-aws%20%7C%20gcp-lightblue?style=flat-square&logo=cloud)
![Kubernetes](https://img.shields.io/badge/kubernetes-ready-blue?style=flat-square&logo=kubernetes)
![Terraform](https://img.shields.io/badge/terraform-managed-623CE4?style=flat-square&logo=terraform)
![DevOps Automation](https://img.shields.io/badge/devops-automated-orange?style=flat-square&logo=githubactions)
![IDP Oriented](https://img.shields.io/badge/platform-internal--developer--platform-critical?style=flat-square&logo=serverfault)
![Deterministic](https://img.shields.io/badge/builds-deterministic-informational?style=flat-square&logo=hashicorp)
![Minimalist](https://img.shields.io/badge/philosophy-minimalist-lightgrey?style=flat-square&logo=leaflet)
![AI Agents](https://img.shields.io/badge/AI-agent--ready-ff69b4?style=flat-square&logo=openai)

> **`foundry`** is my modular, portable, and opinionated development environment. It’s optimized for automation-first workflows, CLI-centric toolchains, and fast machine restore.  
>
> 🔁 Version-controlled with [`yadm`](https://yadm.io), powered by encrypted secrets, containerized CLI tools, and ergonomic shell customizations.

## 🎯 Purpose & Strategy

This project defines a **portable, idempotent, and intuitive** macOS development environment that is:

- ✅ Fast to restore on a new laptop or after a system failure
- 🧱 Modular and maintainable using organized scripts and folders
- 🔐 Secure — sensitive files are encrypted and synced via Bitwarden
- 📦 Git-tracked (via `yadm`) for dotfile management and reproducibility

> ⚠️ This environment is tailored **only for macOS (Apple Silicon)**. Some tooling may work cross-platform, but scripts and paths are macOS-specific.

---

## 📐 Design Principles

> `foundry` is built with a modern engineering philosophy: **terminal-first**, **automation-first**, modular, minimalist, secure, deterministic, and designed to support the coming shift toward AI agents — software that reasons, acts, and collaborates.

| Principle                   | Description                                                                        |
|-----------------------------|------------------------------------------------------------------------------------|
| 🖥️ **Terminal-First**       | CLI-native workflows — no GUI dependencies required                                |
| 🤖 **Automation-First**     | Everything is scriptable, repeatable, and self-healing                             |
| 🧩 **Modular**              | Structured into composable, purpose-specific components                            |
| ⚡ **Ephemeral**            | Easily wiped and rebuilt without manual rework                                     |
| 🛡️ **Idempotent**           | Safe to re-run; produces consistent and predictable state                          |
| 🧮 **Deterministic**        | Given the same input, always produces the same output                              |
| 🤖 **Agent-Oriented**       | Built to complement AI agents — context-aware, augmentable, autonomous             |
| 🧠 **AI-Augmented**         | Whisper, transcription tools, and LLMs enhance developer workflows                 |
| 🧘 **Minimalist**           | No bloat — only intentional tools and configs                                      |
| 🔐 **Secure**               | Secrets encrypted in Bitwarden; zero plain text exposure                           |
| 🧾 **Compliance-Aware**     | Aligns with HIPAA, PII, and audit requirements through encryption and traceability |
| 🔄 **Auto-Maintained**      | Weekly `launchd` jobs keep system and tools fresh                                  |
| 📜 **Declarative**          | Environment defined in scripts, dotfiles, and `Brewfile`                           |
| ☁️ **Cloud-Native**          | Optimized for AWS, GCP, Terraform, Kubernetes, VPN, and SSO tooling                |
| 👀 **Observable**           | Logs and feedback available for background jobs and automations                    |
| 📈 **Trackable**            | Fully version-controlled via `yadm`; reproducible and auditable                    |
| ⚙️  **Efficient**            | Optimized for system resource utilization and fast workflows                       |
| 🚀 **Productive**           | Designed to maximize developer productivity and minimize friction                  |

> 🧭 While some of these principles are aspirational or evolving, they serve as a compass for continuous improvement — guiding how `foundry` grows, simplifies, and adapts to the future of developer environments.

> 🧠 `foundry` isn't just dotfiles — it's a future-proof foundation for building, restoring, and collaborating with intelligent agents in secure, cloud-native, and compliant environments.

---

## 🚀 Bootstrap Strategy

The environment is broken into modular parts under `~/bin/`, making it easy to automate, debug, and customize:

### [`setup`](https://github.com/anbarak/foundry/blob/main/bin/setup)
- **TUI launcher** built with [gum](https://github.com/charmbracelet/gum)
- Provides an interactive menu to run:
  - [`restore`](https://github.com/anbarak/foundry/blob/main/bin/foundry/restore) (initial setup)
  - [`finalize`](https://github.com/anbarak/foundry/blob/main/bin/foundry/finalize) (plugin setup)
  - [`secrets-backup-task.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/secrets-backup-task.sh) / [`secrets-restore-task.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/secrets-restore-task.sh) (Bitwarden secrets)
  - [`lint-dotfiles`](https://github.com/anbarak/foundry/blob/main/bin/foundry/lint-dotfiles)
  - Exit

> 💡 This is the recommended entrypoint for a smooth restore experience:
> ```bash
> ~/bin/setup
> ```

### [`bin/bootstrap/`](https://github.com/anbarak/foundry/blob/main/bin/bootstrap/)
- [`init-machine`](https://github.com/anbarak/foundry/blob/main/bin/bootstrap/init-machine) – Installs Homebrew, sets up base folders
- [`setup-core-tools`](https://github.com/anbarak/foundry/blob/main/bin/bootstrap/setup-core-tools), [`setup-kubernetes-tools`](https://github.com/anbarak/foundry/blob/main/bin/bootstrap/setup-kubernetes-tools)[`setup-terraform-tools`](https://github.com/anbarak/foundry/blob/main/bin/bootstrap/setup-terraform-tools) – Installs key CLI tools and symlinks runners

### [`bin/foundry/`](https://github.com/anbarak/foundry/blob/main/bin/foundry/)
- [`restore`](https://github.com/anbarak/foundry/blob/main/bin/foundry/restore) – Core logic for restoring the dev environment (used by the TUI)
- [`finalize`](https://github.com/anbarak/foundry/blob/main/bin/foundry/finalize) – Handles plugin setups (Oh My Zsh, Powerlevel10k, Tmux, Vim, kubectl Krew, etc.)
- [`lint-dotfiles`](https://github.com/anbarak/foundry/blob/main/bin/foundry/lint-dotfiles) – Validates shell scripts and formatting (can be run manually or via TUI)

### [`bin/tools/secrets/`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/)
- [`secrets-backup-task.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/secrets-backup-task.sh) – Encrypts and uploads secrets to Bitwarden
- [`secrets-restore-task.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/secrets-restore-task.sh) – Downloads secrets and git identity

### `~/bin/runners/`
- Dockerized CLI wrappers (e.g., `kubectl-1.29`, `terraform-1.6`) under [`bin/runners/`](https://github.com/anbarak/foundry/blob/main/bin/runners/)
- Helpers under [`bin/runners/helpers/`](https://github.com/anbarak/foundry/blob/main/bin/runners/helpers/) for launching version-specific tools

---

## 🚀 Get Started

To restore your Foundry environment on a new macOS machine:

### 🧰 1. Clone Your Dotfiles with `yadm`

```bash
yadm clone git@github.com:anbarak/foundry.git
yadm bootstrap
```

This sets up the base folder structure and applies tracked configs.

---

### 🧭 2. Launch the Interactive Setup (Recommended)

```bash
~/bin/setup
```

You’ll get a clean menu UI powered by [`gum`](https://github.com/charmbracelet/gum):

```bash
Choose:
> 🛠  Run Full Restore
  🔐  Restore Secrets Only
  📤  Backup Secrets to Bitwarden
  🔁  Finalize Setup (plugins, completions)
  📦  Lint Dotfiles
  ❌  Exit

←↓↑→ navigate • enter submit
```

Install `gum` if not already:

```bash
brew install gum
```

---

### 🛠 3. Manual Restore (Optional / Advanced)

```bash
~/bin/foundry/restore
```

This will:

1. Run `init-machine` to install Homebrew and core setup
2. Restore secrets (SSH, AWS, kube configs, git identity)
3. Finalize all plugins: Zsh, Powerlevel10k, Tmux, Vim, kubectl Krew, etc.

---

### 🌐 Optional: Set Fast Public DNS (Cloudflare + Google)

Foundry optionally configures your system to use fast, privacy-respecting public DNS resolvers by running `~/bin/tools/networking/set-dns-public.sh`. You’ll be prompted before any changes are applied.

#### ✅ Why use public DNS?

- 🚀 **Speed** – Cloudflare (`1.1.1.1`) and Google (`8.8.8.8`) are often faster than ISP defaults  
- 🛡️ **Security** – Less susceptible to DNS hijacking or ISP-level tampering  
- 🔒 **Privacy** – Avoids DNS-based tracking or monetization by ISPs  
- 🌍 **Stability** – High availability and global performance  
- ⚙️ **Developer-Friendly** – Reduces local DNS cache issues and speeds up CLI workflows  

💡 Ideal for developers, remote workers, or privacy-conscious users. You can re-run the script any time to restore these settings.

---

## 🔐 Secrets & Bitwarden Strategy

Sensitive files are excluded from version control and backed up securely using Bitwarden.

### 🔐 What Gets Backed Up

The backup archive includes:

- `~/.ssh/keys/` – SSH private keys only (not `.pub`, `known_hosts`, or `config`)
- `~/.aws/`
- `~/.gnupg/`
- `~/.kube/`
- `~/.vpn-configs/`
- `~/.gitconfig-centerfield`
- `~/.saml2aws`
- `~/.mylogin.cnf`
- `~/.bitwarden-ssh-agent.sock` is ignored
- `~/.ssh/config`, `*.pub`, and `known_hosts` are excluded for security/audit clarity (they are tracked or manually managed)

> 🎯 All exclusions are handled in `secrets-backup-task.sh` using `tar --exclude=...` flags

### 🔐 SSH Key Strategy

- SSH keys are modularly organized under `~/.ssh/keys/`
- A single `~/.ssh/config` file uses `Include ~/.ssh/includes/*.conf` for service-specific configurations (e.g., GitHub, Bitbucket)
- Public keys (`*.pub`), `config`, and `known_hosts` are excluded from Bitwarden backups and handled in Git or setup scripts
- Only sensitive private keys are encrypted and uploaded

### 🛡️ Linting & Audit Tools

The following scripts help you validate SSH and Bitwarden setup:
[`lint-config.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/ssh/lint-config.sh) – Validates SSH config and included files
[`audit-keys.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/ssh/audit-keys.sh) – Audits private key permissions and ownership
[`check-bitwarden.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/backup/check-bitwarden.sh) – Verifies Bitwarden CLI is logged in and responsive

Run them individually or bundle them into your restore process.

### 💾 Bitwarden Backup/Restore Scripts

[`secrets-backup-task.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/secrets-backup-task.sh) – Encrypt & upload secrets to Bitwarden
[`secrets-restore-task.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/secrets/secrets-restore-task.sh) – Download and extract secrets from Bitwarden

A macOS `launchd` job runs the backup script every **Monday at 9 AM**, ensuring your environment stays in sync and secure.

To install or refresh the job:

[install-secrets-backup.sh](https://github.com/anbarak/foundry/blob/main/bin/tools/system/install-secrets-backup.sh)

---

## ⏱️ Scheduled Maintenance Jobs (via `launchd`)

Three background jobs are automated using macOS `launchd` and run every Monday to ensure your system and secrets stay healthy:

| Task                    | Time       | Script Path                                         | Logs To                          |
|-------------------------|------------|-----------------------------------------------------|----------------------------------|
| ♻️  Restart Reminder     | 08:00 AM   | `~/bin/tools/system/restart-prep.sh`                | `~/logs/restart-prep.log`        |
| 🛠 Homebrew Maintenance | 09:00 AM   | `~/bin/tools/system/brew-maintenance-task.sh`       | `~/logs/brew-maintenance.log`    |
| 🔐 Secrets Backup       | 10:00 AM   | `~/bin/tools/secrets/backup-secrets.sh`             | `~/logs/secrets-backup.log`      |


> ✅ These jobs are automatically installed when running:
>
> ```bash
> ~/bin/foundry/restore
> ```

Or you can install/refresh them manually:

[install-secrets-backup.sh](https://github.com/anbarak/foundry/blob/main/bin/tools/system/install-secrets-backup.sh)
[install-brew-maintenance.sh](https://github.com/anbarak/foundry/blob/main/bin/tools/system/install-brew-maintenance.sh)
[install-restart-reminder.sh](https://github.com/anbarak/foundry/blob/main/bin/tools/system/install-restart-reminder.sh)

---

### 🧪 Debugging launchd Jobs

To confirm jobs are installed:

```bash
launchctl list | grep com.user
```

To check a specific job like Homebrew maintenance

```bash
launchctl list | grep brew
```

To view logs:

```bash
tail -f ~/logs/homebrew_maintenance.log
tail -f ~/logs/secrets-backup.log
```

To reload a job manually:

```bash
launchctl unload ~/Library/LaunchAgents/com.user.brew-maintenance.plist
launchctl load ~/Library/LaunchAgents/com.user.brew-maintenance.plist
```

---

### 🗂️ LaunchAgent Templates

All `.plist.template` files are stored in:
[`bin/tools/system/`](https://github.com/anbarak/foundry/blob/main/bin/tools/system/)

They are dynamically populated at runtime using:

```bash
envsubst < ...template > ...plist
```

> 📦 Tip: To add a new job, copy one of the templates, update the `Label`, `ProgramArguments`, and schedule, then register it using `launchctl`.

---

## 🗓️ Weekly Restart Reminder

- [`install-restart-reminder.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/system/install-restart-reminder.sh) – Installs a macOS LaunchAgent to display a system restart reminder **every Monday at 8 AM**
- [`restart-prep.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/system/restart-prep.sh) – Sends a non-intrusive notification and logs system stats (uptime, memory, disk, swap)
- [`restart-reminder.plist.template`](https://github.com/anbarak/foundry/blob/main/bin/tools/system/restart-reminder.plist.template) – LaunchAgent template used during installation

This reminder helps maintain system health by encouraging regular reboots, which:
- Clear swap and memory leaks
- Restart long-running background services
- Ensure pending system updates apply cleanly

> 🛠️ The reminder is **automatically installed** when running:
> ```bash
> ~/bin/foundry/restore
> ```
>
> Or, you can install it manually:
> ```bash
> ~/bin/tools/system/install-restart-reminder.sh
> ```

All files live under:
```bash
~/bin/tools/system/
```

---

## 📦 Installed Tools & Plugin Ecosystem

This setup includes:

### 🐚 Shell
- `zsh` + `Oh My Zsh` + `Powerlevel10k`
- Plugins: `autojump`, `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`, `colorize`, `docker`, `aws`, `gcloud`, `krew`

### 📦 Package Management
- `Homebrew`, `brew bundle`, `coreutils`, `findutils`, `jq`, `thefuck`, `tealdeer`, `lsd`, `htop`, `asdf`, `direnv`

### 🧠 Vim-style Terminal Navigation & Clipboard Support
- ⌨️ Terminal uses **Vim keybindings** (`bindkey -v`) across Zsh, Tmux, and fzf
- 🧭 Powerlevel10k shows `NORMAL`, 🟩 `INSERT`, 🟪 `VISUAL`, 🟨 `OVR` mode indicators with smart styling
- 🚀 Fast keybinding: `jj` or `jk` in insert mode → switches to normal mode
- 📋 Vim is clipboard-integrated via `set clipboard=unnamedplus`
- ✂️ Tmux supports **visual selection** (`v`) and **yanking** (`y`) with system clipboard via `pbcopy`
- 🔍 Selection feedback, highlighting, and pbcopy piping is preconfigured

#### ⌨️ Quick Reference: Terminal Keybindings (Vi Mode)

| Mode       | Shortcut           | Description                               |
|------------|--------------------|-------------------------------------------|
| Insert     | `jj`, `jk`         | Switch to Normal mode (like `<Esc>`)      |
| Normal     | `0`, `^`, `$`      | Start of line / First char / End of line  |
| Normal     | `v`, `V`, `Ctrl-v` | Start visual, linewise, or block mode     |
| Visual     | `y`                | Yank (copy) selection to clipboard        |
| Normal     | `u`, `Ctrl-r`      | Undo / Redo                               |
| Tmux       | `prefix` + `[`     | Enter copy-mode (use vi keys inside)      |
| Copy Mode  | `v`, `y`           | Begin selection / Copy selection          |

> 🧠 Works consistently across Zsh, Tmux, and fzf when vi-mode is enabled.

### 🛠️ Dev & Cloud Tools
- `kubectl`, `krew`, `k9s`, `terraform`, `awscli`, `session-manager-plugin`, `gcloud`, `tmux`, `vim`, `YouCompleteMe`, `goenv`, `pyenv`, `poetry`, `pipenv`, `bitwarden-cli`, `git-extras`, `gh`, `bb`

---

### 🕵️‍♂️ recent – Recent File Search Tool

Quickly view and interact with the most recently modified files in your development environment.

---

#### 📄 Plain listing of the top 10 recently modified files

```bash
recent ~/bin 10
```

---

#### 📜 Long-format, sorted output with human-readable metadata

```bash
recent-details ~/bin 10
```

Outputs file size, timestamp, and path — sorted by last modified time (descending).

---

#### 🔍 Interactive search with `fzf` + right-pane preview

```bash
recent-fzf ~/bin 20
```

- Displays most recently modified files in `fzf`
- Right pane shows up to 100 lines of preview using [`bat`](https://github.com/sharkdp/bat)
- Handles missing or deleted files gracefully

---

💡 `recent` is fast, ergonomic, and terminal-native — perfect for jumping back to something you just edited.

---

### 🧪 Internals

- Built with portable `bash`, no dependencies outside CLI tools
- Uses modern CLI utilities:
  - `gfind`, `gdate`, `gxargs`, `gsort`, `eza`, `bat`, `fzf`
- Supports:
  - Exclusion of noisy files (`.DS_Store`, kube cache, history files, etc.)
  - `$HOME/.config/devtools/modfiles/include-locations.txt` for default search paths
  - JSON-free, grep/fzf-friendly formatting
  - Three commands: `recent`, `recent-details`, `recent-fzf`

---

### 📦 File Paths

- Script: [`bin/tools/dev/find-recent-files.sh`](https://github.com/anbarak/foundry/blob/main/bin/tools/dev/find-recent-files.sh)
- Aliases and functions: defined in `~/.config/zsh/modules/01-coreutils.zsh`

```zsh
recent         # basic list
recent-details # long format
recent-fzf     # fzf with preview
```

---

## 🎙️ Transcription Tools (Whisper + BlackHole)

This setup supports **offline transcription** of personal voice notes, language learning materials, tutorials, and public media using open-source tools. It also enables **system audio capture** for self-study or productivity use cases.

### 🧠 Capabilities

- 🎧 Transcribe `.m4a`, `.mp3`, `.mp4`, `.webm`, `.mov`, and more
- 🔄 Auto-converts input to `.wav` before processing
- 🌍 Supports **multilingual input** (e.g. Persian, English) using `ggml-large-v3.bin`
- 📋 Optionally copies transcript output directly to your clipboard
- 🖥️ Capture audio from system output (e.g. online lectures, podcasts) via [BlackHole 2ch](https://github.com/ExistentialAudio/BlackHole)

### 📦 Installed Tools

- [`whisper.cpp`](https://github.com/ggerganov/whisper.cpp) – optimized CLI-based transcription
- [`ffmpeg`](https://ffmpeg.org) – for audio/video decoding and conversion
- Whisper models:
  - `ggml-base.en.bin` – fast, English-only
  - `ggml-medium.en.bin` – more accurate English
  - `ggml-large-v3.bin` – best quality, multilingual
- [`BlackHole 2ch`](https://github.com/ExistentialAudio/BlackHole) – virtual audio driver to route system sound

> ✅ All tools and models are set up via `setup-core-tools` and the `Brewfile`.

### 📁 Setup Paths

| Purpose            | Path                                         |
|--------------------|----------------------------------------------|
| Whisper models     | `~/.local/share/whisper/models/`             |
| Audio recordings   | `~/recordings/`                              |
| Custom CLI aliases | `~/.config/zsh/modules/19-transcription.zsh`        |

### 🏃‍♂️ CLI Commands

| Command                | Description                                              |
|------------------------|----------------------------------------------------------|
| `transcribe FILE`      | Transcribes any supported audio/video file               |
| `transcribe-copy FILE` | Same as above + copies the result to your clipboard      |
| `record-system-audio`  | Records output audio using BlackHole                     |
| `transcribe-live`      | Transcribes the most recent recorded file                |
| `record-and-transcribe`| Records → transcribes system output                      |
| `record-and-copy`      | Records → transcribes → copies to clipboard              |

> 🎧 For recording system audio, use a **Multi-Output Device** that includes both BlackHole and your usual speaker or headset.

### 🔊 Optional: Terminal Playback (Quick Preview)

For simple audio previews (e.g. transcription outputs), you can play `.wav` files from the CLI:

```bash
afplay /path/to/audio.wav
```

### 🔊 Playback Helpers

- **Play the most recent recording:**

```sh
alias playlast='afplay "$(ls -t ~/recordings/*.wav | head -n1)"'
```

Quickly plays back the latest .wav recording in your ~/recordings directory using macOS’s afplay. Useful for verifying audio before or after transcription.

> 🛡️ **Reminder**: These tools are intended for **personal and ethical use** (e.g. transcription of language-learning content, tutorials, voice memos, and other non-sensitive material).  
> Please respect all applicable laws and organizational policies when using audio capture or transcription tools.

---

## 🧠 Local AI Integration (Ollama + Aider)

Foundry includes a fully offline, privacy-focused, and terminal-native AI stack powered by [Ollama](https://ollama.com) and [Aider](https://github.com/paul-gauthier/aider). This lets you interact with LLMs for commit messages, code editing, benchmarking, and shell interaction — with no internet, no telemetry, and zero API cost.

---

### 🧠 Recommended Models by Use Case

| Use Case                  | Model             | Notes                                                           |
|---------------------------|-------------------|-----------------------------------------------------------------|
| General Q&A, CLI Chat     | `llama3.2`        | Default model: solid performance with reasonable RAM usage      |
| Small fast responses      | `phi3` / `mistral`| Useful for agents, shell wrappers, and low-latency tasks        |
| Code diffs, commit msgs   | `codellama`       | Optimized for structured text like code                         |
| Diff understanding        | `deepseek-coder`  | Great for complex, multi-file diffs                             |

All supported models are managed from `~/.config/ollama/model-list.txt` and dynamically selected with:

```
switch-model
```

The `ollama_run` function gives flexible model invocation. It accepts an explicit model name (from the list) or falls back to your default.

Examples:

```bash
ollamarun deepseek-coder "Summarize this git diff"
ollamarun "How does EKS differ from ECS?"
```

---

### 🧰 Available AI Aliases & Tools

All AI-related wrappers and utilities are defined in `~/.config/zsh/modules/22-ai.zsh`.

| Alias              | Description                                                     |
|---------------- ---|-----------------------------------------------------------------|
| `ollamarun`        | Smart runner for `ollama run`; auto-pulls & logs usage          |
| `switch-model`     | FZF selector for `~/.config/ollama/model-list.txt`              |
| `ollama-health`    | Health check to ensure local Ollama server is working           |
| `ollama-models`    | List all installed Ollama models                                |
| `ollama-models-fzf`| FZF interface to run a selected model                           |
| `aiwrap`           | Umbrella CLI dispatcher for all AI tools                        |
| `commit-ai`        | Generate AI commit message from current `git diff`              |
| `ycommit-ai`       | Same as above, for YADM-managed files                           |
| `git-llm-commit`   | Alias to trigger local commit AI flow                           |
| `yadm-llm-commit`  | YADM-specific commit wrapper                                    |
| `aider-ai`         | Wrapper for running Aider with the current default model        |
| `aider-commit`     | Use Aider to generate commit messages from diffs                |
| `ai-benchmark`     | Measure LLM latency and subjective quality                      |
| `ai-benchmark-fzf` | FZF-enabled model selector and benchmark runner                 |
| `ai-selftest`      | Quick health check: runs "Say hello" against default model      |

---

### 💬 Example Usage

Ask a question:
```
ollamarun "Explain what this bash function does"
```

Run a specific model:
```
ollamarun codellama "Summarize this diff"
```

Generate commit messages:
```
commit-ai
ycommit-ai
```

Run Aider:
```
aider-ai
aider-commit
```

Run model health check:
```
ai-selftest
```

---

### 📊 Benchmarking & Model Comparison

Foundry supports structured benchmarking across local models.

```bash
ai-benchmark             # Full benchmark with scoring
ai-benchmark --quick     # Speed-only benchmarking
```

Logged to:

- `~/logs/ollama-benchmark.csv`
- `~/logs/ollama-benchmark-subjective.log`

After the benchmark, you'll be prompted to:
- Pin your favorite model
- Auto-select the best model based on scores
- Persist that model to `~/.local/state/foundry/ollama-default-model`

---

### 🔐 Why Local AI?

| Feature            | Local Ollama Setup          | Cloud LLMs (e.g. OpenAI)            |
|--------------------|-----------------------------|-------------------------------------|
| 💵 Cost            | Free forever                | Pay-per-token or $20+/month         |
| 🔒 Privacy         | 100% local, no API calls    | Sends prompts to remote servers     |
| ⚡ Speed           | Instant local responses     | Slower due to network/API latency   |
| 🛠️ Integrations    | Shell + Git native          | Limited or requires SDKs            |
| 🧮 Reproducibility | Deterministic responses     | Subject to backend model drift      |

This stack is ideal for:

- Git workflows
- CLI agents
- Offline dev environments
- Security-sensitive orgs

> 🧠 Designed for infra and platform engineers who want fast, scriptable, secure AI tools — without cloud dependency.

---

## 🎞️ Media Playback & File Associations

This setup includes support for high-quality media playback and ensures audio/video files open consistently in VLC via scripting.

### 📦 Installed Tools

- [`VLC`](https://www.videolan.org/vlc/) — free, open-source media player supporting nearly all formats
- [`duti`](https://github.com/moretension/duti) — CLI tool to manage macOS default app associations

### 🔁 Default App Setup

Default apps are automatically configured during restore (via `setup-core-tools`) by executing:
[set-defaults.sh](https://github.com/anbarak/foundry/blob/main/bin/tools/system/set-defaults.sh)

This script uses `duti` to associate:

| File Type      | Opens With |
|----------------|------------|
| `.mp4`, `.mov` | VLC        |
| `.mp3`, `.m4a` | VLC        |
| `.wav`, `.webm`| VLC        |

You can modify or extend these associations in:
[defaults.duti](.config/duti/defaults.duti)

> ✅ These defaults are re-applied at every shell launch (via `.zshrc.local`), but only if `duti` is available.

---

## 🧠 Local AI Integration (Ollama + Aider)

Foundry supports **fully local, free AI tooling** to enhance commit workflows, code refactoring, and terminal productivity — aligned with principles like *terminal-first*, *agent-oriented*, *minimalist*, and *secure*.

### ✅ Recommended Stack

| Purpose               | Tool/Model                  | Notes                                                                 |
|-----------------------|------------------------------|-----------------------------------------------------------------------|
| LLM runtime           | [Ollama](https://ollama.com)             | Lightweight local LLM runtime with one-line model setup               |
| Chat-style assistant  | `llama3`, `mistral`          | Great for CLI reasoning, docs, small code tasks, & personal assistants|
| Git commit messages   | [`aider`](https://github.com/paul-gauthier/aider) | Generates commits & code suggestions from diffs                       |
| Code reasoning (GUI)  | [`continue`](https://continue.dev)        | Optional VSCode plugin using local models via Ollama                  |
| CLI integration       | [`aider`] or [`cody`](https://sourcegraph.com/cody) | Cody supports Ollama backend for LLM usage                           |
| Prompting API         | `foundry-llm.sh`             | CLI wrapper for `ollama run` (e.g. `llm "summarize this diff"`)      |

### ⚙️ Example Usage

- 💬 Ask a question from the CLI:
  ```bash
  llm "Explain what this bash function does"
  ```

- 🧠 Use `aider` to generate or refine commit messages:
  ```bash
  aider --llm ollama:llama3
  ```

- 📝 Generate commit message from git diff:
  ```bash
  git diff | llm "Write a conventional commit message:"
  ```

- 🤖 Integrate into Git workflow:
  Add a wrapper like `~/bin/git-llm-commit` to automate AI-based messages.

### 🆚 Why This Over Cloud APIs?

| Area                      | Local Stack (Ollama + Aider)                                  | Cloud-Based (OpenAI API, ChatGPT Pro)                                |
|---------------------------|---------------------------------------------------------------|-----------------------------------------------------------------------|
| **Cost**                  | 💸 Free forever                                                | 💵 Pay-per-token or $20+/mo                                           |
| **Privacy**               | 🛡️ Fully offline, no data leaves machine                      | 🔁 Data sent to 3rd-party APIs                                        |
| **Performance**           | ⚡ Near-instant with small models                             | ⏱️ Latency depends on network and service load                        |
| **Reproducibility**       | 🧮 Same input → same result (deterministic)                   | ❓ Results vary depending on model/version updates                     |
| **Customization**         | 🧠 Easy to swap models (llama3, mistral, etc.)                | ⚙️ API selection limited by pricing tiers                             |
| **Security**              | 🔐 Local-only means no accidental data leaks                  | 📡 Exposes sensitive code/prompt context to vendor                    |
| **DevOps Alignment**      | ✅ Scriptable, agent-ready, composable                        | 🚫 Often locked behind rate limits or usage caps                      |

### 🧠 How This Aligns with Foundry

| Foundry Principle    | AI Tool Alignment                                                    |
|----------------------|----------------------------------------------------------------------|
| Terminal-First       | All tools are CLI-native                                             |
| Automation-First     | Can be scripted and wrapped easily                                   |
| Agent-Oriented       | Builds a foundation for prompt-based agents                          |
| Minimalist           | Small footprint, local-only, no telemetry                            |
| Deterministic        | Same model → same result; reproducible                               |
| Secure               | Zero data leaves device                                              |
| Ephemeral            | Models can be wiped/re-pulled in `setup-core-tools`                  |

> 💡 This architecture supports **secure, reproducible, free**, and **offline AI augmentation** — fully aligned with your Foundry vision.

---

## 🖥️ Terminal Customization (Manual)

- Install Nerd Font:

```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

- In Terminal > Settings > Profiles:
  1. Import `gruvbox-dark.terminal`
  2. Set font: `Hack Nerd Font Mono`, style: `Regular`, size: `12`
  3. Spacing: `1`
  4. Window size: `125 x 200`
  5. Set profile as default

> Confirm mouse reporting works in Tmux/Vim.

---

## 🐳 Docker via Colima (Replaces Docker Desktop)

Docker is now powered by [`Colima`](https://github.com/abiosoft/colima) — a lightweight, fast, and scriptable alternative to Docker Desktop using native macOS virtualization.

### 🛠 Installation

Install Colima and the Docker CLI:

```bash
brew install colima docker
```

### 🚀 Start Colima VM

Start Colima with custom resource limits:

```bash
colima start --cpu 2 --memory 2 --disk 20
```

Optional: Start Colima with Kubernetes (via k3s):

```bash
colima start --cpu 2 --memory 4 --disk 20 --kubernetes
```

### 🐳 Usage

The Docker CLI (`docker`, `docker compose`) works out of the box:

```bash
docker ps
docker run hello-world
docker compose up
```

Colima VM management:

```bash
colima stop
colima restart
colima status
```

### 📦 Migration from Docker Desktop

If migrating from Docker Desktop:

- **Images**
  Save from Docker Desktop:
  ```bash
  docker save my-image:tag -o my-image.tar
  ```
  Load into Colima:
  ```bash
  docker load -i my-image.tar
  ```

- **Volumes**
  Migration is manual; recreate or restore via backup.

- **Uninstall Docker Desktop**
  Optional cleanup:
  ```bash
  sudo rm -rf /Applications/Docker.app
  rm -rf ~/.docker ~/Library/Containers/com.docker.docker
  ```

### ✅ Notes

- Colima is scriptable and integrates well with dotfile-based setups.
- You can manage different environments using `colima start --profile <name> ...`.
- Works with your `~/bin/runners/`, aliases, and containerized workflows.

> 💡 This setup eliminates heavy resource usage from Docker Desktop and improves startup time and system performance.

---

## 📄 Tracked Dotfiles via `yadm`

All relevant non-sensitive configuration files are version-controlled using [`yadm`](https://yadm.io), enabling reproducible, portable, and minimal dev environments.

### 🔧 Examples of Tracked Files

- Shell: `~/.bash_profile`, `~/.zshrc`, `.zshrc.local`, `.zshrc.plugins`
- Terminal: `~/.vimrc`, `~/.tmux.conf`, `~/.p10k.zsh`
- Meta: `~/README.md`, `~/.gitignore_global`, `~/.editrc`, `~/.inputrc`

### 🧠 Key Aliases (from `~/.config/zsh/modules/21-yadm.zsh`)

```zsh
alias yst='yadm status'                         # Git status
alias yadd='yadm add'                           # Stage files
alias ylog='yadm log --oneline --graph --decorate'  # Pretty Git log
alias ycm='yadm commit -m'                      # Commit with message
alias ycam='yadm commit -am'                    # Add + commit message
alias ypush='yadm push'                         # Push to origin
alias ypull='yadm pull --rebase'                # Pull remote changes
alias yrestage='yadm restore --staged'          # Unstage from index
```

### 📦 Common Workflow

```bash
yst                      # View modified/staged files
yrestage <file>          # Unstage a file if needed
yadd <file>              # Stage file(s)
ycam "message"           # Commit staged files
ypush                    # Push to origin
```

### 💡 Best Practices

- Use `yrestage` to safely unstage files before committing.
- Keep secrets out of version control — use `yadm encrypt` or Bitwarden (see `secrets-backup-task.sh`).
- Avoid machine-specific or large binary files to keep your setup portable.

> 🧠 Your dotfiles are modular, secure, fast to restore, and deeply integrated into your `foundry` bootstrap workflow.

---

## 🧠 Philosophy

> Your dev environment should never be a mystery.  
> It should be **deterministic**, **modular**, **secure**, and **fast to restore**.

**foundry** represents this philosophy. It’s where every tool, alias, and secret is forged with care.

---

## 💬 Contributing

PRs welcome if you use a similar dotfile strategy and want to generalize any parts.

---

## 📄 License

MIT — use at your own risk, fork at your own will.
