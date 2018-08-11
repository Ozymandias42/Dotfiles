
#ZFS SPECIFIC STUFF
    zpoolLocation=$(which zpool)

[ -f $zpoolLocation ] && {
    
    case $PLATFORM in 
        "Linux")
            defaultMountPoint="/run/media/$(whoami)/ZFS"  
            group="users"
            ;;
        "Darwin")
            defaultMountPoint="/Volumes/ZFS" 
            ;;
        *)
            defaultMountPoint="/mnt/ZFS" 
            ;;
    esac
    export cfs="$defaultMountPoint"
    
    zpooli() {  
        [ ! -d $defaultMountPoint ] && { echo "$defaultMountPoint does not exist. Creating.."  sudo mkdir $defaultMountPoint }
        sudo zpool import -a ${1} -N -R $defaultMountPoint 
        pools=()
        mounts=()
        nameLength=""
        
        #Saving old IFS for later restore and setting new to newline to iterate over multiline cmd output
        IFSOLD=$IFS
        IFS='
'

        for line in $(sudo zfs list|tail -n+2); do
            pool=$(echo $line|cut -d ' ' -f 1)
            #Does not work in macOS because macOS grep does not support -P flag for Perl regex which is required for positive lookahead (?<=...)
            [[ "$PLATFORM" == "Linux"  ]] && mount=$(echo $line|grep -Po '(?<=\s)\/.+' )
            [[ "$PLATFORM" == "Darwin" ]] && mount=$(echo $line|grep -Eo '\/.+')
            pools=( ${pools[@]} $pool )
            mounts=( ${mounts[@]} ${mount:-"-"} )
            [[ ${#pool} -ge $nameLength ]] && nameLength=${#pool}
        done
        IFS=$IFSOLD
        #Debug line
        #for i in {1..${#pools[@]}};do echo "${pools[$i]} ${mounts[$i]}";done
        
        for (( i=1;i<=${#pools[@]};i++ )) ; do
            if [[ "${defaultMountPoint}/${pools[$i]}" == "${mounts[$i]}" ]]; then
                printf "Mounting %${nameLength}s to %s\n" ${pools[$i]} ${mounts[$i]}
                sudo zfs mount ${pools[$i]}
                sudo chown $(whoami) ${mounts[$i]}
                sudo chgrp $group    ${mounts[$i]}
            fi
        done
    } ; 
    
    alias zpoole="sudo zpool export -a" 
}

