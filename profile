# ~/.Profile

DEBUG=1 #0 true, 1 false

#if running bash and .bashrc exist source it.
[[ -n "$BASH_VERSION" ]] && [[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

####
#HELPER FUNCTIONS
####
setIfCmdExist() {
    #USAGE Expl. f. setIfCmdExist $1 $2 $3
    #setIfCmdExist WINEDEBUG "warn-all" wine //$3 is supplied so so it will be checked for
    #via ${3:-${2}} #NOTE: ${var:-x} substitutes x for var if var unset OR empty.
    #USAGE Expl. f. setIfCmdExist $1 $2
    #setIfCmdExist EDITOR vi //$3 does not exist so it will be checked for $2
    
    [[ -f $(which ${3:-${2}}) ]] \
    && export $1=$2 \
    || { [[ $DEBUG -eq 0 ]] && echo "Problem with export $1=$2\n$2 not installed" }
    
} ;


####
#SHELL AND OS INDEPENDENT ENVIRONMENT VARIABLES
####

#PROXY VARIABLES STYLE 1
export PROXY_HTTP=192.168.1.5:3128
export PROXY_HTTPS=192.168.1.5:3128
export PROXY_FTP=192.168.1.5:3128

#PROXY VARIABLES STYLE 2
export HTTP_PROXY=192.168.1.5:3128
export HTTPS_PROXY=192.168.1.5:3128
export FTP_PROXY=192.168.1.5:3128

#LOCALES
export LC_ALL="de_DE.UTF-8"

#VARIABLES DEPENDING ON COMMANDS BEING PRESENT
setIfCmdExist WINEDEBUG "warn-all,relay-all,err-all" wine
setIfCmdExist EDITOR vi
setIfCmdExist VISUAL vi

#OS-INDEPENDENT ALIASES
#Aliases for convenvience and keeping me from accidentially deleting stuff.
alias cls=clear
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias ln='ln -i'
alias ls='ls -Ga'
alias grep='grep --color=auto'
[ -d "$HOME/.wine" ] && alias 'C:'='cd ~/.wine/drive_c/Program\ Files'

###PLOWING A PATH TO THE BINS

####
#HELPER FUNCTIONS
####
inPath() { 
#returns 0 if true, else 1
    #Create array from Path
    tmpPaths=( $(echo $PATH|tr ':' ' ') )
    #echo $tmpPaths
    occurences=0
    for i in ${tmpPaths[@]}; do
        [[ $1 == $i ]] && occurences=$((occurences+1))
        [[ $occurences -eq 1 ]] && ret=0; break
    done
    
    [[ $ret -eq 0 ]] && echo $ret || echo 1
};

# set PATH so it includes user's private bin if it exists.
#NOTE: inPath is required since it seems to be set from somewhere else on some systems.
[[ -d "$HOME/bin" ]] && [[ ! $(inPath "$HOME/bin") -eq 0 ]] && PATH="$HOME/bin:$PATH"

####
#OS SPECIFIC PATHS, ALIASES AND VARIABLES
PLATFORM=$(uname)

#HELPER FUNCTIONS
#USAGE EXAMPLE:
#setPathIfExist /opt/local/bin/port /opt/local/bin:/opt/local/sbin
# => [[ -d /opt/local/bin/port ]] && export /opt/local/...:$PATH
setPathIfExist() { [ -d $1 ] && export PATH=$2:$PATH };
setAlias() { 
    [[ -x $2 ]] \
    && alias $1="$2" \
    || { [[ $DEBUG -eq 0 ]] && echo "$2 is not installed" } 
};

setPATH() {
    for i in $@; do
        setPathIfExist $(echo $i|tr '@' ' ')
    done
};

setVARIABLES() {
    for i in $@; do
        setIfCmdExist $(echo $i|tr '@' ' ')
    done
};

setALIASES() {
    for i in $@; do
        setAlias $(echo $i|tr '@' ' ')
    done
};

setEvals() {
    for i in $@;do
        eval $i
    done
};

####
#ARRAYS WITH OS SPECIFIC STUFF. MIGHT BE SOURCED FROM EXTERNAL FILES LATE RON
####

macPaths=( #Array item format: PATH2Check@PATHS2Set
    #MacPorts
    "/opt/local/bin@/opt/local/bin:/opt/local/sbin"\
    #Fink
    "/sw/bin@/sw/bin:/sw/sbin"\
    #UserScripts folder
    "$HOME/UserScripts@$HOME/UserScripts"\
    )

macVariables=( #Array item format: VARNAME@VALUE[@COMMAND2CHECK4]
#Workaround to get fontsmoothing for wine. See: https://bugs.winehq.org/show_bug.cgi?id=41639
    "FREETYPE_PROPERTIES@truetype:interpreter-version=35"
    )

macAliases=( #Array item format: ALIAS@COMMAND2CHECK4
    "xpra@/Applications/Xpra.app/Contents/MacOS/Xpra" \
    )

freebsdAliases=( )
freebsdEvals=( 
'[ ! -L $(which vi) ] && alias vi=vim' \
)    
    
    case $PLATFORM in
        "Darwin") 
            setPATH $macPaths
            setALIASES $macAliases
            setVARIABLES $macVariables
            if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
            . /opt/local/etc/profile.d/bash_completion.sh
            fi
            ;;
        "Linux")
            ;;
        "FreeBSD")
            #setALIASES $freebsdAliases
            setEvals $freebsdEvals
            ;;
    esac


####
#STUFF TO COMPLEX TO PROCESS IN BATCH. I.E. CUSTOM FUNCTIONS
####

#ZFS SPECIFIC STUFF
if [ -f /usr/sbin/zpool ]; then
    plattform=$(uname)
    
    case $plattform in 
        "Linux")    defaultPath="/run/media/$(whoami)/ZFS" ;;
        "Darwin")   defaultPath="/Volumes/ZFS" ;;
        *)          defaultPath="/mnt/ZFS" ;;
    esac
    
    zpooli() {  sudo zpool import -a ${2} -R ${defaultPath} } ;
    
    alias zpoole="sudo zpool export -a"
fi
