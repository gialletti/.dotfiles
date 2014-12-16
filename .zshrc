# Start
start_time="$(date +%s)"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=2000
setopt appendhistory autocd beep extendedglob nomatch notify AUTO_CD
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit
# End of lines configured by zsh-newuser-install

# Antigen configuration
source ~/.dotfiles/.antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
command-not-found
brew
heroku
git
common-aliases
jump
laravel
node
osx
sudo
EOBUNDLES

antigen bundles <<EOBUNDLES
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
zsh-users/zsh-completions src
EOBUNDLES

antigen theme josh
# alt theme imajes, fwalch, josh, zhann, avit, agnoster
antigen apply
# End of Antigen configuration

# Sources

source ~/.path
source ~/.aliases
source ~/.functions

# Enable highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
# Override highlighter colors
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=white
ZSH_HIGHLIGHT_STYLES[function]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
ZSH_HIGHLIGHT_STYLES[line]='bold'
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[root]='bg=red'


# Colors
zmodload -a colors
zmodload -a autocomplete
zmodload -a complist
PROMPT="%{$fg[white]%}[%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[white]%}%m %{$fg[white]%}%1~]$ "

end_time="$(date +%s)"
# End
echo 'Load time '$((end_time - start_time))' seconds. Good. Let's make some art 2.0!''
