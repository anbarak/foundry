# Development Environment
## References: 
* [youre-missing-out-on-a-better-mac-terminal-experience](https://medium.com/@caulfieldOwen/youre-missing-out-on-a-better-mac-terminal-experience-d73647abf6d7)
* [use-homebrew-zsh-instead-of-the-osx-default](https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/)
* [iterm2-zsh](https://opensource.com/article/20/8/iterm2-zsh)

## Tools/OS:
* OS: macOS
* Software package manager: Homebrew
  * *Don't use Homebrew to install zsh package. Use Oh My Zsh. Use Homebrew for system-wide tools, such as git, a few others (see below)*
* Terminal: Default macOS terminal
* Font: [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)
* Shell: zsh
* Zsh configuration manager framework: [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)
* Zsh plugin manager: [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)
* Terminal multiplexer: [Tmux](https://github.com/tmux/tmux)
* Tmux plugin manager: [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm)
* Text editor: [Vim](https://github.com/vim/vim)
* Vim plugin manager: [vim-plug](https://github.com/junegunn/vim-plug)

## Goal
To create a development environment with the following characteristics:
* only dependency to install Docker Desktop
* light weight
* modern
* efficient
* productive
* easy on the eyes
* portable
* created once and used anywhere (Linux, macOS, Windows)

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
    5. close and open the Terminal  
### 2. Homebrew
* Install homebrew
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
        1. confirm (expected: /bin/zsh)
           ```
           echo $SHELL
           ```
2. Install Oh My Zsh
   ```
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
   ``` 
7. Zsh theme
   * *I used to use [Powerlevel10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh) but since that project is not being actively maintained, I switched to [Starship](https://github.com/romkatv/powerlevel10k#oh-my-zsh)*

   ```
   brew install starship
   starship init zsh > ~/.zshrc.starship   
   ```
   1. Download Starship configuration (I used the following: https://starship.rs/presets/nerd-font), then run the following:
      ```
      starship preset nerd-font-symbols -o ~/.config/starship.toml
      ```
3. Oh My Zsh plugins
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
      
### 4. Tmux
1. Install Tmux
   ```
   brew install tmux
   ```
   * confirm (expected: tmux version)
     ```
     tmux -V
     ```
2. Install Tmux Plugin Manager (TPM)
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
        
        # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
        run '~/.tmux/plugins/tpm/tpm'
        ```
3. Install plugins
   * General steps:
     ```
     1. Add the plugin-name to the `~/.tmux.conf` file like `set -g @plugin '<plugin-name>'`
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
     
### 5. Vim
1. Install Vim plugin manager and plugins
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
      set tabstop=4       " Number of spaces that a <Tab> in the file counts for
      set shiftwidth=4    " Number of spaces to use for each step of (auto)indent
      set expandtab       " Use spaces instead of tabs
      set number          " Show line numbers
      set autoindent      " Copy indent from current line when starting a new line
      set smartindent     " Do smart autoindenting when starting a new line
      set ignorecase      " Ignore case when searching
      set smartcase       " Override 'ignorecase' if search pattern contains uppercase characters
      set hlsearch        " Highlight search results
      set incsearch       " Do incremental searching
      set mouse=a         " Enable mouse support in all modes
      set backspace=indent,eol,start  " Allow backspacing over auto-indent, line breaks, and start of insert
      set encoding=utf-8   " Set default encoding to UTF-8
      set fileformat=unix  " Set default file format to Unix (LF)
      set showcmd         " Show incomplete commands in the bottom right corner
      
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
    5. install [Sourcetree app](https://sourcetreeapp.com/)
    6. install Chrome extensions for Github:
       * [github-hovercard](https://justineo.github.io/github-hovercard/)
       * [octolinker](https://chromewebstore.google.com/detail/octolinker)
   
### 7. Programming Languages run-time

1. YouCompleteMe (for code completion)
   1. Install `python` `cmake` (if not installed)
      ```
      brew install python cmake
      ```
   2. Install `vim` (if not installed)
      ```
      brew install vim
      ```
   3. Install `YouCompleteMe`
      1. Install `Vundle` (if not installed)
         ```
         git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
         ```
      2. configure `.vimrc`
         ```
         set nocompatible              " be iMproved, required
         filetype off                  " required

         " Set the runtime path to include Vundle and initialize
         set rtp+=~/.vim/bundle/Vundle.vim
         call vundle#begin()
         
         " let Vundle manage Vundle, required
         Plugin 'VundleVim/Vundle.vim'
         
         " Add YouCompleteMe plugin
         Plugin 'ycm-core/YouCompleteMe'
         
         call vundle#end()            " required
         filetype plugin indent on    " required
         
         " Other settings you might want to add
         syntax on
         set number
         ```
      3. Instal the plugin via Vim
         ```
         vim +PluginInstall +qall
         ```
   4. Compile YouCompleteMe
      ```
      cd ~/.vim/bundle/YouCompleteMe
      python3 install.py --all
      ```
   5. Configure shell environment (add the following lines to your `.zshrc` file)
      ```
      export PATH="/usr/local/bin:$PATH"
      ```
   6. Reload zsh
      ```
      exec zsh
      ```
   7. Additional Configuration (Optional)
      * You may need to configure YCM further depending on the programming languages you use. This can be done by creating a .ycm_extra_conf.py file in your project directory.

       * Here's a basic example for C++:
       ```              
       # .ycm_extra_conf.py
       def FlagsForFile(filename, **kwargs):
           return {
               'flags': [
                   '-std=c++14',
                   '-x', 'c++',
                   '-I', 'include',
               ],
           }
       ```
       * Place this file in the root of your C++ project directory.
    8. Verify installation
       * Open Vim and type code to see if you get code completion
       
### 8. DevOps tools
    
### 9. Other helpful tools  
9. Tools
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
   6. [lsd](https://github.com/lsd-rs/lsd)
      ```
      brew install lsd
      ```
