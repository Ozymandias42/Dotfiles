# ~/.Profile

#if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# MacPorts (on Mac)
if [ -d /opt/local/bin/port ]; then
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi

#Fink (on Mac)
if [ -d /sw/bin/fink ]; then
    export PATH="/sw/bin:/sw/sbin:$PATH"
fi

export PROXY_HTTP=192.168.1.5:3128
export PROXY_HTTPS=192.168.1.5:3128
export PROXY_FTP=192.168.1.5:3128
#export HTTP_PROXY=192.168.1.5:3128
#export WINEPREFIX="$HOME/Wine Files"
export WINEDEBUG="warn-all,relay-all,err-all"
#export VISUAL=vi
#export EDITOR=vi

#Workaround to get fontsmoothing for wine. See: https://bugs.winehq.org/show_bug.cgi?id=41639
[[ $(uname) == "Darwin" ]] && export FREETYPE_PROPERTIES="truetype:interpreter-version=35"; 

#UserScript Folder on main machine to $PATH
if [ -d $HOME/UserScripts ]; then 
    export PATH=$PATH:$HOME/UserScripts
fi

#Aliases for convenvience and keeping me from accidentially deleting stuff.
alias cls=clear
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias ln='ln -i'
alias ls='ls -Ga'
alias grep='grep --color=auto'

if [ -d "$HOME/.wine" ]; then 
alias 'C:'='cd ~/.wine/drive_c/Program\ Files' 
fi

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
          . /opt/local/etc/profile.d/bash_completion.sh
fi

if [[ -f /Applications/Xpra.app/Contents/MacOS/Xpra ]] && [[ $(uname) == "Darwin" ]]; then
    alias xpra=/Applications/Xpra.app/Contents/MacOS/Xpra
fi

#export LSCOLORS=cxfxcDdCBxegedabagacad
#export CLICOLOR=1

