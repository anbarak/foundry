# Development Environment
## References: 
* [youre-missing-out-on-a-better-mac-terminal-experience](https://medium.com/@caulfieldOwen/youre-missing-out-on-a-better-mac-terminal-experience-d73647abf6d7)
* [use-homebrew-zsh-instead-of-the-osx-default](https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/)
* [iterm2-zsh](https://opensource.com/article/20/8/iterm2-zsh)

## Tools/OS:
* OS: macOS
* Package Manager: Homebrew
  * *Don't use Homebrew to install zsh package. Use Oh My Zsh. Use Homebrew for system-wide tools, such as git, and a few others (see below)*
* Terminal: Default macOS terminal
* Font: [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)
* Shell: zsh
* Zsh configuration manager framework: [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)
* Zsh plugin manager: [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)
* Terminal multiplexer: [Tmux](https://github.com/tmux/tmux)
* Tmux plugin manager: [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm)
* Text editor: [Vim](https://github.com/vim/vim)
* Vim plugin manager: [vim-plug](https://github.com/junegunn/vim-plug)
* Code completion tool: [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)

## Goal
To create a development environment with the following characteristics:
* only dependency to install Docker Desktop (to be done)
* created once and used anywhere (Linux, macOS, Windows)
* Lightweight
* Modern
* Efficient
* Productive
* Easy on the eyes
* Portable
* Free of cost

## Setup
### 1. Terminal
1. Fonts
    1. Download and uncompress the font package from Github: https://github.com/ryanoasis/nerd-fonts/releases
    2. In the terminal, go to the directory where you download the font file, then copy the TFF files to the following directory:
        ```
        cp *.ttf ~/Library/Fonts/
        ```
2. Terminal theme
   * *I used [gruvbox-dark theme](https://github.com/morhetz/gruvbox)*
     
    1. Import the following file to Terminal settings: [gruvbox-dark.terminal](gruvbox-dark.terminal)
    2. Change the Font to `Hack Nerd Font Mono`, style `regular`, size `12`
    3. Change the character spacing to 1
    4. select gruvbox-dark profile as `Default`
    5. In the `Window` tab change the `Window Size` (I changed the Columns to 125 and Rows to 200)
    6. close and open the Terminal
3. Ensure mouse reporting is enabled in macOS Terminal (if not update and restart the Terminal)

   ![image](https://github.com/haarabi/dev-env/assets/2755929/680af9b5-164a-49ca-a627-4f740fe5962b)

### 2. Homebrew
1. Install homebrew
    1. Download 
       ```
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       ```
    2. Set PATH (permanently):
        1. Add the following line to the beginning of both `~/.bash_profile` and `~/.zshrc` files
           ```
           export PATH="/opt/homebrew/bin:$PATH" # For Apple Silicon Macs
           ```
        2. Save files and restart the terminal
        3. confirm (expected: Homebrew version):
           ```
           brew --version
           ```
2. Homebrew code completion
   1. Add homebrew's prefix to the `$fpath` in ~/.zshrc.local
      ```
      fpath=($(brew --prefix)/share/zsh-completions $fpath)
      ```
   2. Enable completion and autoload compinit
      ```
      autoload -Uz compinit
      compinit
      ```
   3. Fix permission for the insecure homebrew share directory
      ```
      sudo chmod -R go-w /opt/homebrew/share
      ```
   5. Reload zsh: `source ~/.zshrc`
### 3. Zsh
1. Install zsh
   ```
   brew install zsh zsh-completions
   ```
   *for upgrading: `brew upgrade zsh zsh-completions`*
   
    1. Confirm (expected: zsh version)
       ```
       zsh --version
       ```
    2. Set zsh as the default shell
       Reference: [use-homebrew-zsh-instead-of-the-osx-default](https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/)
       ```
       sudo chsh -s /bin/zsh
       ```
        1. confirm
           ```
           echo $SHELL # Expected: /bin/zsh
           ```
2. Install Oh My Zsh
   ```
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
   ``` 
3. Zsh theme (Powerlevel10k)
   1. Download [Powerlevel10](https://github.com/romkatv/powerlevel10k)
      ```
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k  
      ```
   2. Add the following line of code to the `~/.zshrc.local` file
      ```
      ZSH_THEME="powerlevel10k/powerlevel10k"
      ```
   3. Restart zsh `source ~/.zshrc`
   4. Go through the Powerlevel10k configuration wizard to select your desired settings 
5. Set `LS_COLORS`
   1. Add the following lines to the `~/.zshrc.local` file
      ```
      export CLICOLOR=1
      export LSCOLORS=GxFxCxDxBxegedabagaced
      ```
   2. Restart zsh `source ~/.zshrc`
   3. Confirm (expected: different color output)
      ```
      ls
      ```
6. Create a script to check for Oh My Zsh updates
   ```
   # Function to check for Oh My Zsh updates and prompt user
   check_omz_update() {
       echo "Checking for Oh My Zsh updates..."
       if omz update | grep -q 'updated successfully'; then
           echo "Oh My Zsh updates are available. Would you like to update? (y/n)"
           read answer
           if [[ $answer == 'y' ]]; then
               omz update
           else
               echo "Update skipped."
           fi
       else
           echo "Oh My Zsh is already up to date."
       fi
   }
   
   # Alias to trigger update check
   alias checkupdates='check_omz_update'
   ```
7. Oh My Zsh plugins
   * Create a file called `~/.zshrc.local` that will store your customizations and plugin management (This keeps the main `~\.zshrc`file clean. The .zshrc.local file referenced in the .zshrc file)
   * Create another file called `~/.zshrc.plugins` that will define the plugin array for the zsh environment (The .zshrc.plugin file is referenced in the .zshrc.local file)
   
   1. [autojump](https://github.com/wting/autojump)
      ```
      brew install autojump
      ```
   3. [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)
      * This was already installed as part of the zsh installation 
   4. [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
      ```
      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
      ```
      1. Add zsh-autosuggestions to the plugins array in `~/.zshrc.plugin`
      2. Run: `exec zsh`
   5. [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
      ```
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
      ```
      1. Add the following line to the beginning of the `.zshrc.local` file
         ```
         Add zsh-syntax-highlighting to the plugins array in `~/.zshrc.plugin`
         ````
   6. [fzf](https://github.com/junegunn/fzf)
      1. Install fzf with Homebrew
         ```
         brew install fzf
         ```
   7. [history](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history)
      * add history to the plugin array
   8. [colorized](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colorize)
      1. Install [chroma](https://github.com/alecthomas/chroma)
         ```
         brew install pygments
         brew install chroma # Optional
         ```
      3. Add the `colorized` to the plugin array in `~/.zshrc.plugins`
      4. Reload the shell
         ```
         source ~/.zshrc
         ```
      5. Confirm
         ```
         ccat "some_file_name"
         ```
      
### 4. Tmux
1. Install Tmux
   ```
   brew install tmux
   ```
   * confirm (expected: tmux version)
     ```
     tmux -V
     ```
2. Install TPM(Tmux Plugin Manager)
   1. Install
      ```
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      ```
   2. Configure
      * Add the following lines of code to your `~/.tmux.conf` file (you will have to create this file)
        ```
        # List of plugins
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'

        # Set vi mode bindings in copy mode
        setw -g mode-keys vi

        # Allow 256 colors (useful for syntax highlighting)
        set -g default-terminal "screen-256color"

        # Copy to macOS clipboard using pbcopy
        bind -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi Escape send-keys -X cancel

        # Ensure vim clipboard works within tmux
        set-option -g default-command "reattach-to-user-namespace -l zsh"
        
        # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
        run '~/.tmux/plugins/tpm/tpm'
        ```
3. Install plugins
   * General steps:
     ```
     1. Add the plugin-name to the `~/.tmux.conf` file like `set -g @plugin '"plugin-name"'`
     2. Run `tmux source ~/.tmux.conf`
     3. Open a Tmux session and reload the configuration with `prefix + I`
     4. (optional) To update all installed plugins, use `prefix + U`
     5. (optional) To remove a plugin, delete or comment out the corresponding `set -g @plugin ...` line in the `~/.tmux.conf` file, then reload the configuration with `prefix + alt + u`
     ```
   * Install the following plugins:
     ```
     # List of plugins
     set -g @plugin 'tmux-plugins/tpm'
     set -g @plugin 'tmux-plugins/tmux-sensible'
     set -g @plugin 'tmux-plugins/tmux-resurrect'
     set -g @plugin 'tmux-plugins/tmux-continuum'
     set -g @plugin 'tmux-plugins/tmux-yank'
     set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
     set -g @plugin 'tmux-plugins/tmux-open'
     set -g @plugin 'tmux-plugins/tmux-logging'
     set -g @plugin 'tmux-plugins/tmux-fpp'
     set -g @plugin 'tmux-plugins/tmux-copycat'

     # Enable automatic restore
     set -g @continuum-restore 'on'
     
     # Adjust save interval (default is every 15 minutes)
     set -g @continuum-save-interval '300'  # save every 5 minutes
    
     # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
     run '~/.tmux/plugins/tpm/tpm'
     ```
   * Add the following configuration to improve Tmux productivity
     ```
     # Set prefix to Ctrl+a
     set -g prefix C-a
     bind C-a send-prefix
     
     # Enable mouse mode
     set -g mouse on
     
     # Improve scrollback buffer size
     set -g history-limit 10000
     
     # Customize status bar appearance
     set -g status-left "[#S]"
     set -g status-right "%H:%M %d-%b-%Y"
     
     # Plugin manager setup (tpm)
     set -g @plugin 'tmux-plugins/tpm'
     run '~/.tmux/plugins/tpm/bin/install_plugins'
     
     # Plugins
     set -g @plugin 'tmux-plugins/tmux-sensible'
     set -g @plugin 'tmux-plugins/tmux-resurrect'
     set -g @plugin 'tmux-plugins/tmux-continuum'
     set -g @plugin 'tmux-plugins/tmux-yank'
     set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
     set -g @plugin 'tmux-plugins/tmux-open'
     set -g @plugin 'tmux-plugins/tmux-logging'
     set -g @plugin 'tmux-plugins/tmux-fpp'
     set -g @plugin 'tmux-plugins/tmux-copycat'
     
     # Enable automatic restore
     set -g @continuum-restore 'on'
          
     # Adjust save interval (default is every 15 minutes)
     set -g @continuum-save-interval '300'  # save every 5 minutes
     			
     # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
     run '~/.tmux/plugins/tpm/tpm'
     ```
   * Install [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard)
     ```
     brew install reattach-to-user-namespace
     ```
     
### 5. Vim
1. Install vim
   ```
   brew install vim
   ```
2. Install Vim plugin manager and plugins
   1. Install `vim-plug`
      ```
      curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      ```
   2. Configure vim-plug in `~/.vimrc` (create the file)
      ```
      " Enable syntax highlighting
      syntax enable
      
      " Essential settings
      set tabstop=4                   " Number of spaces that a <Tab> in the file counts for
      set shiftwidth=4                " Number of spaces to use for each step of (auto)indent
      set expandtab                   " Use spaces instead of tabs
      set number                      " Show line numbers
      set autoindent                  " Copy indent from current line when starting a new line
      set smartindent                 " Do smart autoindenting when starting a new line
      set ignorecase                  " Ignore case when searching
      set smartcase                   " Override 'ignorecase' if search pattern contains uppercase characters
      set hlsearch                    " Highlight search results
      set incsearch                   " Do incremental searching
      set mouse=a                     " Enable mouse support in all modes
      set clipboard=unnamedplus       " Use system clipboard for copy and paste
      set backspace=indent,eol,start  " Allow backspacing over auto-indent, line breaks, and start of insert
      set encoding=utf-8              " Set default encoding to UTF-8
      set fileformat=unix             " Set default file format to Unix (LF)
      set showcmd                     " Show incomplete commands in the bottom right corner
      
      " Source Vim-Plug setup and installation
      if empty(glob('~/.vim/autoload/plug.vim'))
        source ~/.vim/autoload_plugins.vim
      endif
      
      " Source plugin configurations
      source ~/.vim/plugin_config.vim
      ```
   3. Add a file `~/.vim/autoload_plugins.vim`
      ```
      " Contains the Vim-Plug installation and setup

      if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
      endif
      ```
   5. Add a file `~/.vim/plugin_config.vim`
      ```
      " Contains the configuration related to Vim plugins

      " Specify the location where plugins will be installed
      call plug#begin('~/.vim/plugged')
      
      " List of plugins
      Plug 'airblade/vim-gitgutter'        " Git diff in the gutter
      Plug 'dense-analysis/ale'
      Plug 'editorconfig/editorconfig-vim'
      Plug 'ekalinin/dockerfile.vim'
      Plug 'fatih/vim-go'
      Plug 'hashivim/vim-terraform'
      Plug 'itchyny/lightline.vim'
      Plug 'junegunn/fzf'
      Plug 'junegunn/fzf.vim'
      Plug 'mattn/emmet-vim'
      Plug 'preservim/nerdtree'            " File system explorer
      Plug 'terryma/vim-multiple-cursors'
      Plug 'tpope/vim-commentary'
      Plug 'tpope/vim-eunuch'
      Plug 'tpope/vim-fugitive'
      Plug 'tpope/vim-sensible'            " Opinionated defaults
      Plug 'tpope/vim-surround'
      Plug 'vim-airline/vim-airline'
      Plug 'w0rp/ale'
      
      " End of plugin list
      call plug#end()
      ```
   7. Install plugins
      * Reload the `~/.vimrc` file in vim
      ```
      :source ~/.vimrc
      ```
      * Install the plugins
      ```
      :PlugInstall
      ```
      * Once finished, run the following to close vim
      ```
      :close
      ```
   8. (optional) Update plugins
      ```
      :PlugUpdate
      ```
   9. (optional) Uninstall plugin
      1. Remove the plug from the `~/.vimrc` file (the line for the plugin that start with `Plug ...`)
      2. Run the following command to remove the plugin file: `:PlugClean`

### 6. Git
1. Git plugins
   1. git-extras
      ```
      brew install git-extras
      ```
   2. git-completion
      * Add the git-completion file to `~/.zshrc` file
        ```
        curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.git-completion.zsh
        if [ -f ~/.git-completion.zsh ]; then
          source ~/.git-completion.zsh
        fi
        source ~/.git-completion.zsh
        ```
    3. git-credential-manager
       ```
       brew install --cask git-credential-manager
       ```
       * (optional) check for upgrade using `brew upgrade --cask git-credential-manager`

    4. github cli (gh)
       ```
       brew install gh	
       ```
    5. bitbucket cli (bb)
       ```
       brew tap craftamap/tap && brew install bb
       ```
    7. install [Sourcetree](https://sourcetreeapp.com/)
       * Configure `Sourcetree`
       * 
    9. install Chrome extensions for Github:
       * [github-hovercard](https://justineo.github.io/github-hovercard/)
       * [octolinker](https://chromewebstore.google.com/detail/octolinker)
2. Configure git
   ```
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"

   # Preferred editor
   git config --global core.editor "vim"
   
   # Useful aliases to speed up common commands
   git config --global alias.st status
   git config --global alias.co checkout
   git config --global alias.br branch
   git config --global alias.ci commit
   git config --global alias.lg "log --oneline --graph --all --decorate"
   git config --global alias.df diff
   git config --global alias.last "log -1 HEAD"
   
   # Enable color for better readability
   git config --global color.ui auto

   # Configure credential caching to avoid typing my password repeatedly
   git config --global --get-all credential.helper # only if another credential exists.helper exists
   git config --global --unset-all credential.helper # only if another credential exists.helper exists
   git config --global credential.helper osxkeychain

   # Configure SSH for GitHub
   ssh-keygen -t ed25519 -C "your.email@example.com"
   eval "$(ssh-agent -s)"
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   pbcopy < ~/.ssh/id_ed25519.pub
   # Test the SSH connection to both github and bitbucket
   ssh -T git@github.com
   ssh -T git@bitbucket.org
   git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"
   
   # Configure gpg signing (as of 6/24/2024, the gpg commit signature has not been implemented in Bitbucket Cloud)
   brew install gnupg
   # Used the following for the key: RSA (sign only) with 2048 bits keysize and 3y expiration
   gpg --full-generate-key
   # Retrieve the keyid
   gpg --list-secret-keys --keyid-format LONG
   # Configure git to use gpg
   git config --global user.signingkey "YOUR_KEY_ID"
   git config --global commit.gpgSign true
   # Copy the gpg key to put in github (*bitbucket does not support configuring gpg on the UI*)
   gpg --armor --export YOUR_KEY_ID | pbcopy
   # In GitHub, go to profile > security and add the new gpg key (for label use email)
   # Tell git to use gpg
   echo "use-agent" >> ~/.gnupg/gpg.conf
   # Fix the non-interactive issue when gpg expects to run interactive session to prompt for the passphrase
   echo "test message" | gpg --pinentry-mode loopback --clearsign
   gpg-agent --daemon
   ssh-add -l  # List currently added keys
   ssh-add ~/.ssh/id_ed25519  # Add your GPG key if not listed
   ```
   * gitignore (global)
     1. Create a `~/.gitignore_global` file with the following content
        ```
        # macOS system files
        .DS_Store
        .AppleDouble
        .LSOverride
        Icon
        
        # Vim and Neovim swap files
        *.swp
        *.swo
        *.swn
        *.swm
        *.swl
        *.swk
        *.swt
        *.sws
        *.swq
        *.swo
        *.swl
        *.swp
        *.swz
        *.swn
        *.swv
        *.swu
        
        # NeoVim
        *.un~
        
        # Vim
        [._]*.s[a-w][a-z]
        [._]s[a-w][a-z]
        [._]S[A-W][A-Z]
        [._]s[A-W][A-Z]
        *~
        *.[a-z][a-z~]
        
        # tmux
        .tmuxinator.yml
        
        # Python
        __pycache__/
        *.py[cod]
        *$py.class
        
        # Go
        *.exe
        *.exe~
        *.dll
        *.so
        *.dylib
        
        # Bash
        *.sh~
        
        # Docker
        .dockerignore
        .docker/
        
        # Kubernetes
        .kube/
        
        # Terraform
        .terraform/
        terraform.tfstate
        terraform.tfstate.backup
        *.tfplan
        
        # AWS
        .aws-sam/
        
        # GCP
        .gcloud/
        
        # General
        *.log
        *.tmp
        *.bak
        *.old
        *~
        
        # Editor-specific directories
        .idea/
        .vscode/
        
        # macOS specific directories
        .DocumentRevisions-V100/
        .fseventsd/
        
        # zsh
        .zcompdump*
        
        # Ignore macOS spotlight and directory cache
        .Spotlight-V100
        .Trashes
        
        # Windows system files
        Thumbs.db
        ```
     2. Configure git to use the above global ignore file
        ```
        git config --global core.excludesfile ~/.gitignore_global
        ```
     3. GPG signing
        ```
        # Install GPG
        brew install gnupg

        # Generate GPG key
        gpg --full-generate-key

        ```
     5. TODO: Add bash scripts to automate git workflow (e.g. add/commit/push)
     6. TODO: Add the usage of git submodules for dependencies on other repositories
   * Confirm all the settings are sound by viewing the `~/.gitconfig` file

### 7. Programming Languages run-time
1. Go
   1. Install Go
      ```
      brew install go
      ```
   3. configure the environment
      1. Add the following lines to ~/.zshrc.local to set up the Go environment variables
         ```
         # Go environment variables
         export GOPATH=$HOME/go
         export GOROOT=$(brew --prefix golang)/libexec
         export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
         ```
      2. Source the configuration
         ```
         source ~/.zshrc
         ```
   3. Set up Vim for Go dev
      1. Install `vim-go` plugin
         * Add the `faith/vim-go` plugin to the `~/.vim/plugin_config.vim` file
         ```
         call plug#begin('~/.vim/plugged')

         Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
         
         call plug#end()
         ```
         * reload vim and install the plugin with `:PlugInstall`
      2. Configure `vim-go`
         * Add the following to the `~\.vim\autoload_plugins.vim` file
           ```
           " Go development settings
           " Enable goimports to automatically format and organize imports
           let g:go_fmt_command = "goimports"
           
           " Automatically run :GoInstallBinaries after plugin install
           autocmd BufWritePost .vimrc source % | GoInstallBinaries
           
           " Enable syntax highlighting
           syntax enable
           
           " Enable auto-completion
           let g:go_auto_type_info = 1
           
           " Enable linting
           let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
           ```
      3. Install additional Go tools
         ```
         :GoInstallBinaries
         ```
      4. (optional) Keep the Go installation and tools up to date with:
         ```
         brew upgrade go
         :GoUpdateBinaries # In vim to update vim-go binaries
         ```
2. Python
   1. Install Python
      ```
      brew install python
      ```
      * Verify installation (expected: both commands return the correct version)
        ```
        python3 --version
        pip3 --version
      ```
   2. Configure Python environment variables
      1. Add the following lines in the `~/.zshrc` file
         ```
         # Python
         export PATH="/usr/local/opt/python/libexec/bin:$PATH"
         export PATH="$HOME/Library/Python/3.x/bin:$PATH"  # Replace 3.x with your Python version
         ```
      2. Apply the changes to the current shell session: `source ~/.zshrc`
   3. Configure vim for Python
      1. Add the following to the `~/.vim/plugin_config.vim` file
         ```
         " Use vim-plug to manage plugins
         call plug#begin('~/.vim/plugged')
         
         " Python development plugins
         Plug 'vim-python/python-syntax'
         Plug 'davidhalter/jedi-vim'
         Plug 'tmhedberg/SimpylFold'
         " Add other Python-related plugins as needed
         
         call plug#end()
         
         " Python-specific settings
         autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
         ```
      2. Install plugins
         ```
         :PlugInstall
         ```
   3. (optional) Install pyenv
   4. (optional) Install pipenv
3. Node
   ```
   brew install node
   ```
   1. (optional) Install `nvm`
      * Didn't install
        ```
        Install nvm:
        brew install nvm
        mkdir ~/.nvm
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
        echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"' >> ~/.zshrc
        source ~/.zshrc
         Install Node.js:
        nvm install --lts
        ```
5. YouCompleteMe (for code completion)
   * ensure python3 is used (open `vim` and enter `:version`, there should be `+` next to `python3`; if not, install python3 (as shown below)
   1. Install `python` `cmake` (if not installed)
      ```
      brew install python cmake
      ```
   2. Install `vim` (if not installed)
      ```
      brew install vim
      ```
   3. Install `YouCompleteMe`
      * Add the following line to `~/.vim/plugin_config.vim` file
        ```
        Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --all' }
        ```
      * Add the Python executable path in `~/.vim/autoload_plugins.vim` file
        ```
        " Enable YCM with Python 3
        let g:ycm_python_binary_path = '/opt/homebrew/bin/python3'
        
        " Tell YCM not to prompt for confirmation when loading the .ycm_extra_conf.py
        let g:ycm_confirm_extra_conf = 0
        ```
      * Add extra Go configuration to `~/.vim/autoload_plugins.vim` to enhance the vim configuration
        ```
        " Go configuration
        let g:go_def_mode='gopls'
        let g:go_info_mode='gopls'
        ```
      * Install plugins
        ```
        :PlugInstall
        ```
   4. Install language support
      ```
      # npm (node) is required to set up Tern (a JavaScript code analyzer)      
      
      # The installation of setuptools is not necessary but improves performance
      cd ~/.vim/plugged/YouCompleteMe
      
      # Create a virtual environment named 'ycm_venv'
      python3 -m venv ~/ycm_venv
      
      # Activate the virtual environment
      source ~/ycm_venv/bin/activate
      
      # Install setuptools in the virtual environment
      pip install setuptools

      # Deactivate the virtual environment
      deactivate

      # Re-activate the virtual environment if needed (only if YCM or dependencies require it)
      source ~/ycm_venv/bin/activate
      
      # Run YCM installation script (assuming you're in the YCM directory)
      python3 install.py --all
      
      # Deactivate the virtual environment after installation completes
      deactivate
      ```
   5. Configure YCM for specific languages (e.g. Go, Python)
      1. Create a `~/.ycm_extra_conf.py` file
      2. Add the following to the file
         ```
         def Settings(**kwargs):
             client_data = kwargs['client_data']
             filetype = client_data['&filetype']
         
             if filetype == 'python':
                 return {
                     'interpreter_path': '/opt/homebrew/bin/python3',  # Specific path to python3
                     'sys_path': [
                         '/opt/homebrew/lib/python3.12/site-packages',
                     ]
                 }
         
             if filetype == 'go':
                 return {
                     'ls': {
                         'cmd': ['gopls'],
                     }
                 }
         
             return {}
         ```
         * You determine the `interpreter_path` and the `sys_path` for Python by running the following Python code snippet in the terminal (*I modified my interpreter path to be more generic Python path so that if I upgrade my Python it won't break*)
           ```
           import sys
   
           print("Interpreter Path:", sys.executable)
           Interpreter Path: /opt/homebrew/opt/python@3.12/bin/python3.12
           print("System Path:")
           System Path:
           >>> for path in sys.path:
           ...     print(path)
           ```
    6. Additional configuration for tools
       1. Add the following to the `~/.zshrc.local` file
          ```
          # Linux commands
          alias ls='ls --color=auto'
          alias grep='grep --color=auto'
          alias ll='ls -lAh'         # Detailed list with hidden files, human-readable sizes
          alias la='ls -A'           # List all files except . and ..
          alias l='ls -CF'           # List directories with /
          alias ..='cd ..'           # Move up one directory
          alias ...='cd ../..'       # Move up two directories
          alias mv='mv -i'           # Prompt before overwrite
          alias cp='cp -i'           # Prompt before overwrite
          alias rm='rm -i'           # Prompt before delete
          alias mkdir='mkdir -p'     # Create directories recursively
          alias cls='clear'          # Clear terminal
          alias h='history'          # Show history
          
          # Log file navigation and manipulation
          alias tailf='tail -f'                      # Follow the tail of a file
          alias tail100='tail -n 100'                # Show the last 100 lines of a file
          alias tail200='tail -n 200'                # Show the last 200 lines of a file
          alias tail500='tail -n 500'                # Show the last 500 lines of a file
          alias tail1k='tail -n 1000'                # Show the last 1000 lines of a file
          alias tail2k='tail -n 2000'                # Show the last 2000 lines of a file
          alias tailf100='tail -f -n 100'            # Follow last 100 lines of a file
          alias tailf200='tail -f -n 200'            # Follow last 200 lines of a file
          alias tailf500='tail -f -n 500'            # Follow last 500 lines of a file
          alias tailf1k='tail -f -n 1000'            # Follow last 1000 lines of a file
          alias tailf2k='tail -f -n 2000'            # Follow last 2000 lines of a file
          alias tailerr='tail -f /var/log/error.log' # Follow error log file
          alias tailsys='tail -f /var/log/syslog'    # Follow system log file
          alias tailauth='tail -f /var/log/auth.log' # Follow authentication log file
          
          # System operations
          alias update='sudo apt update && sudo apt upgrade -y'  # Update system (Ubuntu/Debian)
          alias df='df -h'                                       # Show disk usage
          alias du='du -h -d 1'                                  # Show directory sizes
          alias top='htop'                                       # Use htop if available
          alias path='echo -e ${PATH//:/\\n}'                    # Show PATH variable
          
          # Networking
          alias ip='ip -c -br addr'                              # Show IP addresses
          alias ports='netstat -tulanp'                          # Show listening ports
          alias ping='ping -c 5'                                 # Ping with 5 packets
          
          # SSH
          alias ssh_server='ssh user@server.com'                 # Quick SSH to server
          
          # Docker commands
          alias dk='docker'
          alias dkb='docker build'                               # Build image
          alias dkc='docker-compose'                             # Docker Compose
          alias dki='docker images'                              # List images
          alias dkp='docker ps'                                  # List running containers
          alias dkpa='docker ps -a'                              # List all containers
          alias dkr='docker run'                                 # Run container
          alias dkrm='docker rm'                                 # Remove container
          alias dkrmi='docker rmi'                               # Remove image
          alias dkl='docker logs'                                # Show logs
          alias docker_stop_all='docker stop $(docker ps -aq)'   # Stop all running Docker containers
          alias docker_rm_all='docker rm $(docker ps -aq)'       # Remove all stopped Docker containers
          alias docker_rmi_all='docker rmi $(docker images -q)'  # Remove all Docker images
          alias docker_prune='docker system prune -af'           # Remove all unused Docker data
          
          # Kubernetes commands
          alias k='kubectl'
          alias kctx='kubectl config use-context'                       # Switch context
          alias kns='kubectl config set-context --current --namespace'  # Set namespace
          alias kget='kubectl get'                                      # Get resources
          alias kdesc='kubectl describe'                                # Describe resources
          alias klogs='kubectl logs'                                    # Show logs
          alias kapply='kubectl apply -f'                               # Apply configuration
          alias kdel='kubectl delete -f'                                # Delete configuration
          alias kexec='kubectl exec -it'                                # Execute command in pod
          alias k9s='k9s'                                               # K9s Kubernetes CLI
          
          # Terraform commands
          alias tf='terraform'
          alias tfa='terraform apply'                            # Apply configuration
          alias tfp='terraform plan'                             # Show execution plan
          alias tfd='terraform destroy'                          # Destroy infrastructure
          alias tfv='terraform validate'                         # Validate configuration
          alias tff='terraform fmt'                              # Format configuration
          alias tfi='terraform init'                             # Initialize Terraform
          alias tfu='terraform state show'                       # Show resource state
          alias tfw='terraform workspace'                        # Terraform workspace
          alias tfw_list='terraform workspace list'              # List Terraform workspaces
          alias tfw_new='terraform workspace new'                # Create new Terraform workspace
          alias tfw_select='terraform workspace select'          # Select Terraform workspace
          
          # Go development aliases
          alias gobuild='go build'                   # Compile packages and dependencies
          alias goinstall='go install'               # Compile and install packages and dependencies
          alias gotest='go test'                     # Run tests
          alias goclean='go clean'                   # Remove object files
          alias godep='go mod tidy'                  # Add missing and remove unused modules
          alias gomod='go mod'                       # Dependency module maintenance
          alias gofmt='gofmt -w'                     # Format Go code
          alias golint='golint'                      # Run golint
          alias govet='go vet'                       # Run go vet
          alias goget='go get'                       # Download and install packages and dependencies
          alias gocover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'  # Generate coverage report and open in browser
          alias goreplace='go mod edit -replace'     # Edit replace directives
          alias goclone='go get -d'                  # Download modules to GOPATH but don't build
          alias goenv='go env'                       # View Go environment information
          alias gorelease='goreleaser'               # Create releases and package Go projects
          alias gomodv='go mod verify'               # Verify dependencies have expected content
          
          # Python development aliases
          alias py='python3'                     # Use python3 as default Python interpreter
          alias py2='python2'                    # Use python2 as default Python interpreter
          alias ipy='ipython'                    # Launch IPython interactive shell
          alias pip='python3 -m pip'             # Use pip for Python package management
          alias pip2='python2 -m pip'            # Use pip for Python2 package management
          alias venv='python3 -m venv'           # Create Python virtual environments
          alias pyfmt='autopep8 --in-place'      # Format Python code using autopep8
          alias pylint='python3 -m pylint'       # Run pylint for static code analysis
          alias pytest='python3 -m pytest'       # Run pytest for testing
          alias pyvenv='source venv/bin/activate' # Activate Python virtual environment
          alias pyrun='python3'                  # Run Python script
          alias pydoc='python3 -m pydoc'         # Use pydoc for Python documentation
          alias pyprof='python3 -m cProfile'     # Profile Python code
          
          # Git aliases
          alias gst='git status'                          # Show the working tree status
          alias gl='git log --oneline --graph --decorate' # Show the commit history in a graphical way
          alias ga='git add'                              # Add file contents to the index
          alias gaa='git add .'                           # Add all modified files to the index
          alias gb='git branch'                           # List, create, or delete branches
          alias gba='git branch -a'                       # List all remote and local branches
          alias gbd='git branch -d'                       # Delete a branch
          alias gc='git commit -m'                        # Record changes to the repository
          alias gca='git commit --amend'                  # Amend the last commit
          alias gco='git checkout'                        # Switch branches or restore working tree files
          alias gcb='git checkout -b'                     # Create and switch to a new branch
          alias gd='git diff'                             # Show changes between commits, commit and working tree, etc.
          alias gds='git diff --staged'                   # Show changes between the index and the HEAD
          alias gf='git fetch'                            # Download objects and refs from another repository
          alias gfa='git fetch --all'                     # Fetch all remotes
          alias gfo='git fetch origin'                    # Fetch from the 'origin' remote
          alias gp='git push'                             # Update remote refs along with associated objects
          alias gpa='git push --all'                      # Push all branches to the remote repository
          alias gpo='git push origin'                     # Push to the 'origin' remote
          alias gpl='git pull'                            # Fetch from and integrate
          
          # Git aliases (continued)
          alias gplo='git pull origin'                    # Pull changes from the 'origin' remote
          alias gpr='git pull --rebase'                   # Rebase local changes on top of the upstream branch
          alias gm='git merge'                            # Join two or more development histories together
          alias grh='git reset --hard'                    # Reset the current HEAD to the specified state
          alias grs='git reset --soft'                    # Reset the current HEAD to the specified state, keeping staged changes
          alias gcl='git clone'                           # Clone a repository into a new directory
          alias gss='git stash save'                      # Stash changes in a dirty working directory
          alias gsp='git stash pop'                       # Apply stashed changes to the working directory
          alias gstl='git stash list'                     # List all stashed changes
          alias grb='git rebase'                          # Reapply commits on top of another base tip
          alias grba='git rebase --abort'                 # Abort a rebase
          alias grbc='git rebase --continue'              # Continue a rebase after resolving conflicts
          alias gclean='git clean -fd'                    # Remove untracked files from the working directory
          alias gprune='git remote prune origin'          # Prune all stale remote-tracking branches
          alias gundo='git reset HEAD~1'                  # Undo the last commit
          
          # GitHub aliases
          alias gh='gh'                    # GitHub CLI entry point
          alias ghpr='gh pr create'        # Create a pull request
          alias ghip='gh issue create'     # Create a new issue
          alias ghr='gh repo'              # Manage repositories
          alias ghb='gh repo browse'       # Open the GitHub repository in the browser
          
          # Bitbucket aliases
          alias bb='bb'                    # Bitbucket CLI entry point
          alias bbpr='bb pr create'        # Create a pull request
          alias bbissue='bb issue create'   # Create a new issue
          alias bbb='bb browse'            # Open the Bitbucket repository in the browser
          
          # AWS CLI commands
          alias aws_profile='aws configure --profile'                                              # Switch profile
          alias ec2_ls='aws ec2 describe-instances'                                                # List EC2 instances
          alias ec2_start='aws ec2 start-instances --instance-ids'                                 # Start EC2 instance
          alias ec2_stop='aws ec2 stop-instances --instance-ids'                                   # Stop EC2 instance
          alias s3_ls='aws s3 ls'                                                                  # List S3 buckets
          alias s3_cp='aws s3 cp'                                                                  # Copy files to/from S3
          alias s3_sync='aws s3 sync'                                                              # Sync files with S3
          alias lambda_ls='aws lambda list-functions'                                              # List Lambda functions  
          alias fargate_run='aws ecs run-task --launch-type FARGATE'                               # Run Fargate task
          alias fargate_deploy='ecs-cli compose --file path/to/your/docker-compose.yml service up' # Deploy AWS Fargate service
          alias ssh_ec2='ssh -i path/to/your/ec2_key.pem ec2-user@your-ec2-instance'               # SSH into EC2 instance
          
          # GCP CLI commands
          alias gcp_auth='gcloud auth login'                     # Authenticate GCP
          alias gcp_config='gcloud config configurations list'   # List configurations
          alias gcp_set='gcloud config set'                      # Set configuration
          alias gcp_project='gcloud config set project'          # Set project
          alias gcp_zones='gcloud compute zones list'            # List zones
          alias gcp_instances='gcloud compute instances list'    # List instances
          
          # Homebrew commands
          alias brewup='brew update; brew upgrade; brew cleanup'    # Update Homebrew and upgrade all packages
          
          # Tmux commands
          alias tmux='tmux -2'                                      # Force tmux to assume 256-color terminal
          alias ta='tmux attach -t'                                 # Attach to a tmux session
          alias tls='tmux ls'                                       # List tmux sessions
          alias tks='tmux kill-session -t'                          # Kill tmux session
          alias tka='tmux kill-server'                              # Kill tmux server
          
          # Custom aliases
          alias edit_zshrc='vim ~/.zshrc.local'                  # Edit .zshrc.local
          alias src_zshrc='source ~/.zshrc.local'                # Source .zshrc.local
          alias edit_ycm='vim ~/.ycm_extra_conf.py'              # Edit YCM configuration
          alias src_ycm='source ~/.ycm_extra_conf.py'            # Source YCM configuration
          
          # Vim aliases
          alias vim='vim'                                  # Start Vim normally
          alias vi='vim'
          alias v='vim'
          alias vimdiff='vim -d'                           # Open Vim in diff mode
          alias vimrc='vim ~/.vimrc'                       # Edit ~/.vimrc
          alias vimplug='vim ~/.vim/autoload_plugins.vim'  # Edit Vim plugins autoload file
          alias vimtmp='vim -u NONE -N'                    # Open Vim with no plugins and in nocompatible mode
          alias vimcd='vim -c "cd %:p:h"'                  # Open Vim and change to the directory of the current file
          alias vimtab='vim --remote-tab'                  # Open the file in a new tab in an existing Vim instance
          alias vimsplit='vim --remote-silent'             # Open file in a new split in an existing Vim instance
          ```
6. [Tabnine](https://www.tabnine.com/)
   1. Install coc-tabnine
      * Add the following line to the `~/.vim/plugin_config.vim` file
        ```
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        ```
   2. Open vim, run `:PlugInstall`
   3. In vim, run `CocInstall coc-tabnine`
   4. In vim, run `:CocConfig`
   5. In vim, add the following code to the `coc-settings.json` file
      ```
      {
        "suggest.noselect": false,
        "suggest.enablePreselect": true,
        "tabnine.experimentalAutoImports": true,
        "tabnine.showProbabilities": true,
        "tabnine.priority": 100
      }
      ```
   6. Restart vim
### 8. DevOps tools
1. Docker
   1. Install Docker Desktop
      ```
      brew install --cask docker
      ```
      * Confirm
        ```
        docker --version
        docker run hello-world
        ```
   2. Configure Docker Desktop
      * Set up the Docker Desktop options as follows (for MacBook Pro M1 Pro with 16 GB memory specs):
        ![image](https://github.com/haarabi/dev-env/assets/2755929/6ad63deb-fa8a-489f-9741-1c59abae9ce2)
        ![image](https://github.com/haarabi/dev-env/assets/2755929/a16138e7-5cf3-4b25-a1b1-394c4b9dca05)
        ![image](https://github.com/haarabi/dev-env/assets/2755929/4e1bf8cc-bfff-4b25-8b92-b58ee39d389f)
        ![image](https://github.com/haarabi/dev-env/assets/2755929/b402612d-3a7a-41c4-8e04-f36beb6968d1)
        ![image](https://github.com/haarabi/dev-env/assets/2755929/064a22a8-1c60-44ee-9d15-9d5599bbcf8a)
        ![image](https://github.com/haarabi/dev-env/assets/2755929/a733c5ad-b834-4db2-b733-c1e9a276466d)
        * In the `Docker Engine` section, in the code block write the following:
          ```
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
         ![image](https://github.com/haarabi/dev-env/assets/2755929/b47b8ad1-7dc7-40af-82c1-06788dfe6bf6)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/eca447b0-2e3d-44ec-a2f8-813cef127789)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/9c98ba13-cb63-40ff-bbbc-c666cf26f6ec)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/08a1309b-de69-47b1-b3de-d40350e26dde)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/fea0be1e-d3f5-488b-b53b-73ac28821676)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/b04c0e00-31a2-4f56-aab8-ec4233a7ca67)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/60d5a5f2-4dbf-4fe3-8741-5ba0a91aac40)
         ![image](https://github.com/haarabi/dev-env/assets/2755929/71f056fa-085b-4801-b1ac-e44a2dba0982)
   3. [Docker completion](https://docs.docker.com/config/completion/#zs)
      1. Download `Docker Completion`
         ```
         curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
         ```
      2. Add `docker` to the plugin block in `~/.zshrc.plugins`
         ```
         plugins=(... docker)
         ```
      3. Source the Zsh configuration:
         ```
         source ~/.zshrc
         ```
2. AWS CLI
   1. Install
      ```
      brew install awscli
      ```
      * Confirm (expected: awc cli version)
        ```
        aws --version
        ```
   2. Enable AWS CLI command completion
      1. Add `aws` to the plugins array in `~/.zshrc.plugins` file
      2. Source the updated .zshrc file
         ```
         source ~/.zshrc
         ```
   3. Configure
      1. Configure AWS CLI for the Default profile:
         ```
         aws configure
         ```
      2. Set up additional profiles
         ```
         aws configure --profile work
         ```
         ```
         aws configure --profile personal
         ```
3. GCP CLI
   1. Install Google Cloud SDK
      ```
      brew install --cask google-cloud-sdk
      ```
   2. Add `gcloud` to the plugins array in `~/.zshrc.plugins` file
   3. Add `gcp` to the plugins array in `~/.zshrc.plugins` file
   4. Source the updated .zshrc file
      ```
      source ~/.zshrc
      ```
   5. confirm by typing `gcloud [TAB]
4. Kubectl
   1. Install
      ```
      brew install kubectl
      ```
   2. Confirm (expected: version)
      ```
      kubectl version --client
      ```
   3. Configure
      TODO: Add steps
   4. Enhance with plugins
      1. Download and install [krew](https://github.com/kubernetes-sigs/krew)
         ```
         (
           set -x; cd "$(mktemp -d)" &&
           OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
           ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
           KREW="krew-${OS}_${ARCH}" &&
           curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
           tar zxvf "${KREW}.tar.gz" &&
           ./"${KREW}" install krew
         )
         ```
      2. Add `krew` to the `~/.zshrc.local` file
         ```
         export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
         ```
      3. Install the most useful Kubectl plugins using Krew
         ```
         kubectl krew install ctx
         kubectl krew install ns
         kubectl krew install tree
         kubectl krew install ktop
         kubectl krew install whoami
         kubectl krew install neat      
         ```
   5. Shell auto-completion
      1. Add `kubectl` to the plugin array in ~/.zshrc.plugins
      2. Generate autocompletion script
         ```
         sudo mkdir -p /usr/local/share/zsh/site-functions/
         sudo kubectl completion zsh | sudo tee /usr/local/share/zsh/site-functions/_kubectl > /dev/null 
         ```
      3. Activate autocompletion in zsh
         ```
         autoload -Uz compinit && compinit
         ```
      4. Reload zsh configuration
         ```
         source ~/.zshrc
         ```
   6. Install [k9s](https://github.com/derailed/k9s)
      ```
      brew install k9s
      ```
5. Terraform
   1. Install
      ```
      brew install terraform
      ```
   2. Confirm (expected: version)
      ```
      terraform --version
      ```
   3. Enhance with plugin
      * Add `terraform` to the plugin array in ~/.zshrc.plugins   
### 9. Other helpful tools  
1. [jq](https://github.com/jqlang/jq)
   ```
   brew install jq
   ```
2. [tldr](https://github.com/tldr-pages/tldr)
   ```
   brew install tldr
   ```
3. [tre](https://github.com/dduan/tre)
   ```
   brew install tre-command
   ```
4. [thefuck](https://github.com/nvbn/thefuck)
   ```
   brew install thefuck
   ```      
5. [grammary](https://grammarly.com)
   ```
   brew install --cask grammarly-desktop
   ```
6. [lsd](https://.com/lsd-rs/lsd)
   ```
   brew install lsd
   ```
7. [htop](https://github.com/htop-dev/htop)
   ```
   brew install htop
   ```
8. [postman](https://www.postman.com/)
   ```
   brew install --cask postman
   ```
