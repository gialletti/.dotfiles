#!/usr/bin/env bash

# Set up gpg-agent automatically
if [ -x "$(command -v gpg)" ]; then
    if [ -f $HOME/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
        source $HOME/.gnupg/.gpg-agent-info
        export GPG_AGENT_INFO
    else
        eval $(gpg-agent --daemon --write-env-file $HOME/.gnupg/.gpg-agent-info)
    fi
fi
