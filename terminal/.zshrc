# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/root/.oh-my-zsh"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  web-search history-substring-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#
alias ztheme='(){ export ZSH_THEME="$@" && source $ZSH/oh-my-zsh.sh }'

# echo $PROMPT_OVERRIDE
print_prod_message() {
  clear
  RED=$(tput setaf 1)
  printf "%40s\n" "${RED}"
  printf '  ______                            __    _       ___     _      __  ____  __  __\n' 
  printf ' /_  __/ ___ _  ____  ___ _  ___   / /_  (_)     / _ |   | | /| / / / __/ / / / /\n' 
  printf '  / /   / _ `/ / __/ / _ `/ / -_) / __/ _       / __ |   | |/ |/ / _\ \  /_/ /_/ \n' 
  printf ' /_/    \_,_/ /_/    \_, /  \__/  \__/ (_)     /_/ |_|   |__/|__/ /___/ (_) (_)  \n' 
  printf '                    /___/                      \n'
  printf ' \n'
  printf ' \n'
  printf ' Warning: Your requests can make changed in AWS Account!!! \n'
  printf ' \n'
  printf ' \n'
  NEWLINE=$'\n'
  PROMPT="%{$fg[red]Connected to AWS!!%} ${NEWLINE}"$PROMPT
}

print_local_message() {
  printf '    __                 __    __           __   \n'
  printf '   / /  ___  _______ _/ /__ / /____ _____/ /__ \n'
  printf '  / /__/ _ \/ __/ _ `/ (_-</ __/ _ `/ __/  '"'"'_/ \n'
  printf ' /____/\___/\__/\_,_/_/___/\__/\_,_/\__/_/\_\  \n'
  printf ' \n'
  printf ' \n'
  
}

if [[ "${TARGET}" == "AWS" ]]; then
 print_prod_message
else
  print_local_message
fi
