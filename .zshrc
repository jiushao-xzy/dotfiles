#prompt
PROMPT="%F{cyan}%n%f%F{green}@%f%F{yellow}%m%f %F{blue}%~%f %# "
#%n user
#%m hostname
#%~ workdir
#%# userClass
PROMPT_EOL_MARK=""  # 新增此行：消除行尾不完整行时的百分号

#history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

#autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^[[C' forward-word

#autojump
[[ -s /home/xzy/.autojump/etc/profile.d/autojump.sh ]] && source /home/xzy/.autojump/etc/profile.d/autojump.sh

alias ls="ls --color=auto"

#fastfetch
#fastfetch | lolcat
