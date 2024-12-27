#!/usr/bin/env bash

# detect OS
case "$(uname -sr))" in
    Linux*)     os=linux;;
    Darwin*)    os=macosx;;
    *)          os="unkown"
esac

# install git
if [ $os = 'linux' ]; then
sudo apt update && apt -y install git
fi

# install gh cli
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

# github login
gh auth login

cd ~ && git clone --recurse-submodules https://github.com/chaoyangnz/dotfiles-${os}.git .dotfiles && cd -
cd ~/.dotfiles && bash script/bootstrap.sh && cd -

