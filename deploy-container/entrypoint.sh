#!/bin/bash

START_DIR="${START_DIR:-/home/coder/adventure-game}"

PREFIX="Code Server"
GIT_REPO="https://github.com/UntoldGam/Text-Based-Adventure-Game.git"
mkdir -p $START_DIR


# function to clone the git repo or add a user's first file if no repo was specified.
#project_init () {
 #   git remote add origin $GIT_REPO $START_DIR && git pull origin/main
#}

# start the project
#project_init

# Add dotfiles, if set
if [ -n "$DOTFILES_REPO" ]; then
    # grab the files from the remote instead of running project_init()
    echo "[$PREFIX] Cloning dotfiles..."
    mkdir -p $HOME/dotfiles
    git clone $DOTFILES_REPO $HOME/dotfiles

    DOTFILES_SYMLINK="${RCLONE_AUTO_PULL:-true}"

    # symlink repo to $HOME
    if [ $DOTFILES_SYMLINK = "true" ]; then
        shopt -s dotglob
        ln -sf source_file $HOME/dotfiles/* $HOME
    fi

    # run install script, if it exists
    [ -f "$HOME/dotfiles/install.sh" ] && $HOME/dotfiles/install.sh
fi

echo "[$PREFIX] Starting code-server..."
# Now we can run code-server with the default entrypoint
/usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 $START_DIR
