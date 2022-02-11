#!/usr/bin/env bash
sudo apt-get install -y build-essential
sudo apt-get install -y vim git
git config --global user.name "imotai"
git config --global user.email "codego.me@gmail.com"
addgnupghome imotai
gpg --full-generate-key
gpg --export --armor "codego.me@gmail.com"
git config --global commit.gpgsign true
