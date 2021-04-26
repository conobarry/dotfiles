#!/usr/bin/env sh
dotfiles="~/.dotfiles/"

# Bash
yaml() {
    python3 -c "import yaml;print(yaml.safe_load(open('$1'))$2)"
}

echo $(yaml ~/~.dotfiles/install.conf.yaml "['link']")
