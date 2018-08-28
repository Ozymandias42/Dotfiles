# Dotfiles
_My Dotfiles for a lot of stuff_  
These are the sub-directory structure and files of my .dotfiles directory for use with the rcm dotfile manager.   
(see: https://github.com/thoughtbot/rcm) 

### Note to anyone not me:
How this works:  
There's a file called `osindeprc` which is basically a little program that is being called from the rcfiles of whatever shell I happen to use. For Bash this would be `$HOME/.bashrc` for zsh `$HOME/.zshrc`

What `osindeprc` does:  
It determines the OS used by means of `uname` and then checks for the existance of a bunch of files.
If they do exist they get "sourced" `source filename` or `. filename`

This together with the tag-something folders inside of `$HOME/.dotfiles` allow me to have `rcm` create symlinks to the files I want to have sourced by `osindeprc`  
On Linux that might be a OS-specific `.env-linux` file which contains the Linux specific aliases, global variables and little helper functions and the OS-independend `.env` file which contains aliases and global variables that are used on all POSIX OSs

In the same way there is a OS-indepenent `.functionsrc`

### Addendum to the really curious
Now of course there might be aliases, global variables or helper-functions, OS-independent or OS-dependent that still might not work or make sense to be set in the first place, without certain programs being installed.

For this very reason most elements of that nature are written in form of lists of tuples of this form:  
```bash
macVariables=( VARNAME1@VALUE[@COMMAND2CHECK4] VARNAME2@VALUE[@COMMAND2CHECK4] )
```
inside of `osindeprc` there then are functions which parse these arrays, split the tuples along their separators `@` into arguments and pass those to functions.  
Those functions ultimately set the variable to the desired value, given that the command the variable is _for_ exists.
