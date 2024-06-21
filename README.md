# Development Environment
## References: 
* [youre-missing-out-on-a-better-mac-terminal-experience](https://medium.com/@caulfieldOwen/youre-missing-out-on-a-better-mac-terminal-experience-d73647abf6d7)
* [use-homebrew-zsh-instead-of-the-osx-default](https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/)
* [iterm2-zsh](https://opensource.com/article/20/8/iterm2-zsh)

## Tools/OS:
* OS: macOS
* Software package manager: Homebrew
* Terminal: Default macOS terminal
* Font: [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)
* Shell: zsh
* Zsh configuration manager framework: [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)

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
1. Terminal theme
   * *I used [gruvbox-dark theme](https://github.com/morhetz/gruvbox)*
     
    1. Import the following file to Terminal settings: [gruvbox-dark.terminal](gruvbox-dark.terminal)
    2. Change the Font to `Hack Nerd Font Mono`, style `regular`, size `12`
    3. Change the character spacing to 1
    4. select gruvbox-dark profile as `Default`
    5. close and open the Terminal
   
3. Install homebrew
    1. Download 
       ````
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       ````
    2. Set PATH (permanently):
        1. Add the following line to the beginning of both `~/.bash_profile` and `~/.zshrc` files
           ````
           export PATH="/opt/homebrew/bin:$PATH" # For Apple Silicon Macs
           ````
        2. Save files and restart the terminal
        3. confirm (expected: Homebrew version):
           ````
           brew --version
           ````
4. Fonts
    1. Download and uncompress the font package from Github: https://github.com/ryanoasis/nerd-fonts/releases
    2. In the terminal, go to the directory where you download the font file, then copy the TFF files to the following directory:
        ````
        cp *.ttf ~/Library/Fonts/
        ````
5. Install zsh
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
6. Install Oh My Zsh
   ````
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

   ````   
7. Zsh theme
   * *I used to use [Powerlevel10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh) but since that project is not being actively maintained, I switched to [Starship](https://github.com/romkatv/powerlevel10k#oh-my-zsh)*

   ````
   brew install starship
   starship init zsh > ~/.zshrc.starship   
   ````
   1. Download Starship configuration (I used the following: https://starship.rs/presets/nerd-font), then run the following:
      ````
      starship preset nerd-font-symbols -o ~/.config/starship.toml
      ````
 
