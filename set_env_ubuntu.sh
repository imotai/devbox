#!/usr/bin/env bash
source ./env.sh
sudo apt-get install -y build-essential
sudo apt-get install -y vim git
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"
addgnupghome "$USER_NAME"
gpg --full-generate-key
gpg --export --armor "$USER_EMAIL"
git config --global commit.gpgsign true
echo "export GPG_TTY=\$(tty)" >> ~/.bashrc
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
sudo update-alternatives --config pinentry
gpg-connect-agent reloadagent /bye
