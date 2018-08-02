# ~/.Profile


#if running bash and .bashrc exist source it.
[[ -n "$BASH_VERSION" ]] && [[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

[ -f $HOME/.osindeprc ] && . $HOME/.osindeprc

