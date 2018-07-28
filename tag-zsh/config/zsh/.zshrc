#According to https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout#71258
#zshrc is to initialise the behaviour and features of the interactive shell.

#ZSH feature options to be used.
#setopt single_line_zle
setopt complete_in_word #allow autocompletion to act on words.
setopt INC_APPEND_HISTORY #append when writing to pre-existing history.
setopt hist_ignore_all_dups #don't save duplicates in history
setopt BANG_HIST #use bash like history
setopt extended_glob #allow bash like globbing
setopt AUTO_MENU #create menu from autocompletions

autoload -U colors && colors
autoload -U compinit select-word-style
if [ -f ${ZDOTDIR:-$HOME}/.zcompdump  ]; then
compinit -d ${ZDOTDIR:-$HOME}/.zcompdump -i
else
compinit -i
fi
select-word-style bash

#make shit work on lnux
if [ `uname` = "Linux" ]; then
    bindkey "^[[1;5D" backward-word
    bindkey "^[[1;5C" forward-word
fi


zstyle ':completion:*' menu select

if [ -e $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi 


#Set Colors.
#BLUE="%F{33}"
BLUE="%F{blue}"
BLACK="%{$fg[default]%}"
GREEN="%{$fg[green]%}"

ID="%n@%m:"
DIR="%3~"
#CWD="%3~"
#function precmd {
#     PADS=$((${COLUMNS}-$((${#${(%)ID}}+${#${(%)DIR}}))-1))
#     PAD=${(l.PADS.. .)}
#     PS1="%B$BLUE""%n@%m%f%b$BLACK:$PAD%3~ $BLUE
#%B%#%b $BLACK"
#}
PS1="%B$BLUE""%n@%m%f%b$BLACK:%3~ 
$BLUE%B%#%b $BLACK" 

#Set PS1-Prompt
#"["$BLUE"zsh"$BLACK"]

#SHIT DOESNT WORK FOR CASE AND HAS SHIT DEBUGGING
#Parsing of general .profile for all POSIX compliant shells.
#[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

#WORKING SHIT
#source ~/.profile
[ -e ${HOME}/.osindeprc ] && source ${HOME}/.osindeprc
