# Development Environment
## References: 
* [youre-missing-out-on-a-better-mac-terminal-experience](https://medium.com/@caulfieldOwen/youre-missing-out-on-a-better-mac-terminal-experience-d73647abf6d7)
* [use-homebrew-zsh-instead-of-the-osx-default](https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/)
* [iterm2-zsh](https://opensource.com/article/20/8/iterm2-zsh)

## Tools/OS:
* OS: MacOs
* Software package manager: Homebrew
* Terminal: Default macOS terminal
* Font: [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)
* Shell: zsh
* Zsh configuration manager framework: [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki)

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
1. Install homebrew
    1. Download 
       ````
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       ````
    2. Set PATH (permenantly):
        1. Add the following line to the beginning of both `~/.bash_profile` and `~/.zshrc` files
           ````
           export PATH="/opt/homebrew/bin:$PATH" # For Apple Silicon Macs
           ````
        2. Save files and restart the terminal
        3. confirm (expected: Homebrew version):
           ````
           brew --version
           ````
3. Fonts
    1. Download and uncompress the font package from Github: https://github.com/ryanoasis/nerd-fonts/releases
    2. In the terminal, go to the directory where you download the font file, then copy the TFF files to the following directory:
        ````
        cp *.ttf ~/Library/Fonts/
        ````
4. Install zsh
   ````
   brew install zsh zsh-completions
   ````
   *for upgrading: `brew upgrade zsh zsh-completions`*
   
    1. Confirm (expected: zsh version)
       ````
       zsh --version
       ````
    2. Set zsh as the default shell
       Reference: [use-homebrew-zsh-instead-of-the-osx-default](https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/)
       ````
       sudo chsh -s /bin/zsh

        1. confirm (expected: /bin/zsh)
           ````
           echo $SHELL
           ````
       

   
6. 
