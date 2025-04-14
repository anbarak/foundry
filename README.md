# Dev Environment Setup (macOS)

## 🎯 Purpose & Strategy

This project defines a **portable, idempotent, and intuitive** macOS development environment that is:

- ✅ Fast to restore on a new laptop or after a system failure
- 🧱 Modular and maintainable using organized scripts and folders
- 🔐 Secure — sensitive files are encrypted and synced via Bitwarden
- 📦 Git-tracked (via `yadm`) for dotfile management and reproducibility

> ⚠️ This environment is tailored **only for macOS (Apple Silicon)**. Some tooling may work cross-platform, but scripts and paths are macOS-specific.

---

## 🚀 Bootstrap Strategy

The environment is broken into the following parts:

### `~/bin/bootstrap/`
- `init-machine` – Installs Homebrew and core folders
- `setup-core-tools`, `setup-kubernetes-tools`, `setup-terraform-tools` – Installs CLI helpers and links runners

### `~/bin/dev-env/`
- `restore` – Main entrypoint to restore full environment
- `finalize` – Handles plugin setups (Oh My Zsh, Tmux, Vim, Krew, etc.)
- `lint-dotfiles` – Runs shellcheck and format validations

### `~/bin/secrets/`
- `backup.sh` – Encrypts and uploads secrets to Bitwarden
- `restore.sh` – Downloads secrets archive and Git config from Bitwarden
- `ensure-cron.sh` – Adds a crontab entry to auto-backup secrets every weekday at 9 AM

### `~/bin/runners/`
Containerized wrappers for `kubectl` and `terraform` (via Docker), with helpers under `helpers/`.

---

## 🔁 Restore Flow

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

## 🐳 Docker Desktop (Manual Setup)

Docker Desktop is **not installed via Homebrew**.  
Download from [docker.com](https://www.docker.com/products/docker-desktop).

After install, open **Docker Desktop → Settings** and apply the following configuration:

### 🧠 CPU / Memory / Swap Settings

![CPU Config](https://github.com/haarabi/dev-env/assets/2755929/a16138e7-5cf3-4b25-a1b1-394c4b9dca05)  
![Memory Config](https://github.com/haarabi/dev-env/assets/2755929/6ad63deb-fa8a-489f-9741-1c59abae9ce2)  
![Swap Config](https://github.com/haarabi/dev-env/assets/2755929/4e1bf8cc-bfff-4b25-8b92-b58ee39d389f)

### 🧱 Docker Engine (JSON)

Go to **Settings → Docker Engine** and replace the config with:

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "storage-driver": "overlay2",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  },
  "features": {
    "buildkit": true
  }
}
```

### 🔧 Additional Screenshots for Configuration Reference

![General Settings](https://github.com/haarabi/dev-env/assets/2755929/b402612d-3a7a-41c4-8e04-f36beb6968d1)  
![Disk Settings](https://github.com/haarabi/dev-env/assets/2755929/064a22a8-1c60-44ee-9d15-9d5599bbcf8a)  
![Advanced Tabs](https://github.com/haarabi/dev-env/assets/2755929/a733c5ad-b834-4db2-b733-c1e9a276466d)  
![Kubernetes Settings](https://github.com/haarabi/dev-env/assets/2755929/9c98ba13-cb63-40ff-bbbc-c666cf26f6ec)  
![VM Settings](https://github.com/haarabi/dev-env/assets/2755929/fea0be1e-d3f5-488b-b53b-73ac28821676)  
![Resources Storage](https://github.com/haarabi/dev-env/assets/2755929/b04c0e00-31a2-4f56-aab8-ec4233a7ca67)  
![File Sharing Settings](https://github.com/haarabi/dev-env/assets/2755929/60d5a5f2-4dbf-4fe3-8741-5ba0a91aac40)  
![Software Updates](https://github.com/haarabi/dev-env/assets/2755929/71f056fa-085b-4801-b1ac-e44a2dba0982)

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
