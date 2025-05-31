# Dev Environment Setup (macOS)

![macOS](https://img.shields.io/badge/os-macOS%20(Apple%20Silicon)-blue?style=flat-square&logo=apple)
![Terminal First](https://img.shields.io/badge/terminal-first-lightgrey?style=flat-square&logo=gnubash)
![Whisper Enabled](https://img.shields.io/badge/transcription-ready-blueviolet?style=flat-square&logo=whisper)
![Automation](https://img.shields.io/badge/restore-fully--automated-success?style=flat-square&logo=githubactions)
![Dotfile Managed](https://img.shields.io/badge/dotfiles-managed%20by%20yadm-9cf?style=flat-square&logo=git)
![Cloud Ready](https://img.shields.io/badge/cloud-aws%20%7C%20gcp-lightblue?style=flat-square&logo=cloud)
![Kubernetes](https://img.shields.io/badge/kubernetes-ready-blue?style=flat-square&logo=kubernetes)
![Terraform](https://img.shields.io/badge/terraform-managed-623CE4?style=flat-square&logo=terraform)
![IDP Oriented](https://img.shields.io/badge/platform-internal--developer--platform-critical?style=flat-square&logo=serverfault)
![DevOps Automation](https://img.shields.io/badge/devops-automated-orange?style=flat-square&logo=githubactions)

## 🎯 Purpose & Strategy

This project defines a **portable, idempotent, and intuitive** macOS development environment that is:

- ✅ Fast to restore on a new laptop or after a system failure
- 🧱 Modular and maintainable using organized scripts and folders
- 🔐 Secure — sensitive files are encrypted and synced via Bitwarden
- 📦 Git-tracked (via `yadm`) for dotfile management and reproducibility

> ⚠️ This environment is tailored **only for macOS (Apple Silicon)**. Some tooling may work cross-platform, but scripts and paths are macOS-specific.

---

## 🚀 Bootstrap Strategy

The environment is broken into modular parts under `~/bin/`, making it easy to automate, debug, and customize:

### `~/bin/setup`
- **TUI launcher** built with [gum](https://github.com/charmbracelet/gum)
- Provides an interactive menu to run:
  - `restore` (initial setup)
  - `finalize` (plugin setup)
  - `backup.sh` / `restore.sh` (Bitwarden secrets)
  - `lint-dotfiles`
  - Exit

> 💡 This is the recommended entrypoint for a smooth restore experience:
> ```bash
> ~/bin/setup
> ```

### `~/bin/bootstrap/`
- `init-machine` – Installs Homebrew, sets up base folders
- `setup-core-tools`, `setup-kubernetes-tools`, `setup-terraform-tools` – Installs key CLI tools and symlinks runners

### `~/bin/dev-env/`
- `restore` – Core logic for restoring the dev environment (used by the TUI)
- `finalize` – Handles plugin setups (Oh My Zsh, Powerlevel10k, Tmux, Vim, kubectl Krew, etc.)
- `lint-dotfiles` – Validates shell scripts and formatting (can be run manually or via TUI)

### `~/bin/secrets/`
- `backup.sh` – Encrypts and uploads secrets to Bitwarden
- `restore.sh` – Downloads secrets and git identity
- `ensure-cron.sh` – Sets up a weekday cron job to auto-backup secrets at 9 AM

### `~/bin/runners/`
- Dockerized CLI wrappers (e.g., `kubectl-1.29`, `terraform-1.6`)
- Helpers under `~/bin/runners/helpers/` for launching version-specific tools

---

## 🔁 Restore Flow

### 🧭 One-Liner TUI Launcher (Recommended)

To launch the interactive setup menu:

```bash
~/bin/setup
```

You’ll get a clean menu UI powered by [`gum`](https://github.com/charmbracelet/gum) with options to:

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

### 🛠 Manual Restore (Advanced)

If you prefer running scripts directly (e.g., in CI or custom automation), use:

```bash
~/bin/dev-env/restore
```

This will:

1. Run `init-machine` to install Homebrew and core setup
2. Restore secrets (SSH, AWS, kube configs, git identity)
3. Finalize plugins: zsh, Oh My Zsh, Powerlevel10k, Vim, Tmux, kubectl krew, etc.

---

## 🔐 Secrets & Bitwarden Strategy

These paths are excluded from version control and backed up:

- `~/.ssh/`
- `~/.aws/`
- `~/.gnupg/`
- `~/.kube/`
- `~/.vpn-configs/`
- `~/.gitconfig-centerfield`
- `~/.saml2aws`
- `~/.mylogin.cnf`

Use:

```bash
~/bin/secrets/backup.sh   # to push updated secrets
~/bin/secrets/restore.sh  # to pull them from Bitwarden
```

> ✅ A cron job is configured to run `backup.sh` every weekday at 9 AM via `ensure-cron.sh`.  
> Confirm it’s installed: `crontab -l`

---

## 🗓️ Weekly Restart Reminder

- `install-restart-reminder.sh` – Installs a macOS LaunchAgent to display a system restart reminder **every Monday at 8 AM**
- `restart-prep.sh` – Sends a non-intrusive notification and logs system stats (uptime, memory, disk, swap)
- `restart-reminder.plist.template` – LaunchAgent template used during installation

This reminder helps maintain system health by encouraging regular reboots, which:
- Clear swap and memory leaks
- Restart long-running background services
- Ensure pending system updates apply cleanly

> 🛠️ The reminder is **automatically installed** when running:
> ```bash
> ~/bin/dev-env/restore
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
- `Homebrew`, `brew bundle`, `coreutils`, `findutils`, `jq`, `thefuck`, `tldr`, `lsd`, `htop`, `asdf`, `direnv`

### 🛠️ Dev & Cloud Tools
- `kubectl`, `krew`, `k9s`, `terraform`, `awscli`, `session-manager-plugin`, `gcloud`, `tmux`, `vim`, `YouCompleteMe`, `goenv`, `pyenv`, `poetry`, `pipenv`, `bitwarden-cli`, `git-extras`, `gh`, `bb`

---

## 🎙️ Transcription Tools (Whisper + BlackHole)

This setup includes tools for **offline transcription** of audio and video files, and **system audio capture** via BlackHole for things like Zoom calls, YouTube videos, or Google Meet recordings.

### 🧠 Capabilities

- 📁 Transcribe `.m4a`, `.mp3`, `.mp4`, `.webm`, `.mov`, and other formats
- 🔄 Auto-converts input to `.wav` before transcription
- 🌍 Supports multilingual input (Farsi, English, etc.) via `ggml-large-v3.bin`
- 🎧 Record system audio using [BlackHole 2ch](https://github.com/ExistentialAudio/BlackHole)
- 📋 Auto-copy transcripts to clipboard (for ChatGPT or docs)

### 📦 Installed Tools

- [`whisper.cpp`](https://github.com/ggerganov/whisper.cpp) — high-performance Whisper CLI
- [`ffmpeg`](https://ffmpeg.org) — audio/video conversion and recording
- Whisper models:
  - `ggml-base.en.bin` – fast, low resource
  - `ggml-medium.en.bin` – balanced accuracy/speed
  - `ggml-large-v3.bin` – most accurate, multilingual
- [`BlackHole 2ch`](https://github.com/ExistentialAudio/BlackHole) — virtual audio sink for system recording

> ✅ These tools are included in the `Brewfile` and installed automatically via `setup-core-tools`.

### 📁 Setup Paths

| Purpose         | Path                                         |
|------------------|----------------------------------------------|
| Whisper models   | `~/.local/share/whisper/models/`             |
| Audio recordings | `~/recordings/`                              |
| CLI functions    | `~/.config/zsh/modules/99-custom.zsh`        |

### 🏃‍♂️ CLI Commands

| Command               | Description                                      |
|------------------------|--------------------------------------------------|
| `transcribe FILE`      | Transcribes any audio/video file                |
| `transcribe-copy FILE` | Transcribes and copies the result to clipboard  |
| `record-system-audio`  | Records system audio (via BlackHole 2ch)        |
| `transcribe-live`      | Transcribes the most recent system recording    |
| `record-and-transcribe`| Records then transcribes system audio           |
| `record-and-copy`      | Records → transcribes → copies to clipboard     |

> 🎧 For system audio capture, route your Mac’s output through a Multi-Output Device that includes BlackHole 2ch.

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

All relevant files (non-sensitive) are version-controlled, including:

- `~/.bash_profile`, `~/.zshrc`, `.zshrc.local`, `.zshrc.plugins`
- `~/.vimrc`, `~/.tmux.conf`, `~/.p10k.zsh`
- `~/README.md`, `~/.gitignore_global`, `~/.editrc`, `~/.inputrc`

```bash
yadm status
yadm commit -am "Updated dotfiles"
yadm push
```

---

## 🧠 Philosophy

> Your dev environment should never be a mystery.  
> It should be **deterministic**, **modular**, **secure**, and **fast to restore**.

---

## 💬 Contributing

PRs welcome if you use a similar dotfile strategy and want to generalize any parts.

---

## 📄 License

MIT — use at your own risk, fork at your own will.
