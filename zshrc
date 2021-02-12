export CLICOLOR=1
export FZF_DEFAULT_COMMAND="rg --files --follow"

# Command history configuration
HISTFILE=$HOME/.private/shell_history
HISTSIZE=10000
SAVEHIST=10000

# history with format yyyy-mm-dd
alias history='fc -il 1'

setopt auto_cd
setopt append_history
setopt extended_history         # Record timestamp of command in HISTFILE
setopt hist_expire_dups_first   # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups         # Ignore duplication command history list
setopt hist_ignore_all_dups     # If duplicate to be added, remove older instance in history
setopt hist_ignore_space        # Ignore commands that start with space
setopt hist_verify              # Upon history 'selection', require carriage return to execute
setopt inc_append_history       # Add commands to HISTFILE in order of execution
setopt share_history            # Share command history data

fpath=($HOME/.zsh/completions $fpath)

[[ -f ~/.dotfiles/shell_aliases ]] && source ~/.dotfiles/shell_aliases
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Asumming a clean enviroment installation…%f"
    print -P "%F{33}▓▒░ %F{34}Installing zinit…%f%b"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin"

    print -P "%F{33}▓▒░ %F{34}Installing vim plugins…%f%b"
    command vim +PlugInstall +qall
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Plugins
zinit light-mode for \
    hlissner/zsh-autopair \
    lukechilds/zsh-nvm \
    rupa/z \
    zdharma/fast-syntax-highlighting \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-rust \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \


zinit ice as"program" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zinit load BurntSushi/ripgrep

zinit ice as"program" from"gh-r"
zinit load ericchiang/pup

zinit ice as"program" from"gh-r" pick"*/delta"
zinit load dandavison/delta

zinit ice as"program" from"gh-r"
zinit light starship/starship
eval "$(starship init zsh)"

zinit ice as"program" from"gh-r" mv"jq-* -> jq"
zinit load stedolan/jq
