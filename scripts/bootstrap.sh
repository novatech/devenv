#!/bin/bash
set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

USR=${1:-azwan}
NVIM_VERSION=0.6.0
DELTA_VERSION=0.9.1
TREESITTER_VERSION=0.20.1
SHFMT_VERSION=3.4.1
SHELLCHECK_VERSION=0.8.0

function setup_baseos() {
  microdnf install -y --nodocs \
    tar \
    gcc \
    gcc-c++ \
    cmake \
    which \
    findutils \
    procps-ng \
    git-core \
    git-lfs \
    curl \
    python3 \
    python3-pip \
    python3-virtualenv \
    npm \
    unzip \
    xz \
    fontconfig \
    sudo
  npm i -g yarn
  ln -sn /usr/bin/python3 /usr/bin/python
  pip3 install --upgrade pip
  sed -i 's/^LANG=.*/LANG="en_US.utf8"/' /etc/locale.conf
  /usr/sbin/useradd -m "${USR}"
  echo "%${USR} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers
}

function setup_toolings() {
  mkdir -p "/home/${USR}/.config/"
  mkdir -p "/home/${USR}/devtools/bin"
  curl -fL "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz" | tar -zxvf - -C /tmp/scripts
  mv "/tmp/scripts/nvim-linux64/" "/home/${USR}/devtools/nvim"
  curl -fL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" | tar -zxvf - -C /tmp/scripts
  cp "/tmp/scripts/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta" "/home/${USR}/devtools/bin/delta"
  curl -fL "https://github.com/tree-sitter/tree-sitter/releases/download/v${TREESITTER_VERSION}/tree-sitter-linux-x64.gz" | zcat - >/tmp/scripts/tree-sitter && chmod +x /tmp/scripts/tree-sitter
  cp "/tmp/scripts/tree-sitter" "/home/${USR}/devtools/bin/tree-sitter"
  curl -fL "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64" >/tmp/scripts/shfmt && chmod +x /tmp/scripts/shfmt
  cp "/tmp/scripts/shfmt" "/home/${USR}/devtools/bin/shfmt"
  curl -fL "https://github.com/jesseduffield/lazygit/releases/download/v0.31.4/lazygit_0.31.4_Linux_x86_64.tar.gz" | tar -zxvf - -C /tmp/scripts
  cp "/tmp/scripts/lazygit" "/home/${USR}/devtools/bin"
  curl -fL https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz | tar -xJv -C /tmp/scripts
  cp "/tmp/scripts/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" "/home/${USR}/devtools/bin"
  ln -sn "/home/${USR}/devtools/nvim/bin/nvim" "/home/${USR}/devtools/bin/nvim"
  cp -r "/tmp/scripts/nvim" "/home/${USR}/.config"
  cp "/tmp/scripts/dotfiles/bashrc" "/home/${USR}/.bashrc"
  cp "/tmp/scripts/dotfiles/inputrc" "/home/${USR}/.inputrc"
  cp "/tmp/scripts/dotfiles/flake8" "/home/${USR}/.config/flake8"
  cp -r "/tmp/scripts/fonts" "/home/${USR}/.fonts"
  chown -R "${USR}:${USR}" "/home/${USR}/"
}

function setup_user_nvim() {
  su - "${USR}" -c 'python -m pip install --upgrade --user neovim pynvim'
  su - "${USR}" -c 'python -m pip install --upgrade --user wheel clang-format cmakelang debugpy pytest'
  su - "${USR}" -c '~/devtools/bin/nvim --headless +PlugInstall +qall'
  su - "${USR}" -c '~/devtools/bin/nvim --headless "+TSUpdateSync bash c cpp cmake comment dockerfile html java javascript json5 lua perl python regex toml vim query" +qall'
  su - "${USR}" -c '~/devtools/bin/nvim --headless "+LspInstall --sync clangd cmake bashls dockerls vimls jsonls yamlls sumneko_lua pylsp" +qall'
  su - "${USR}" -c 'fc-cache -fv ~/.fonts'
}

function cleanup() {
  microdnf clean all
  rm -rf /var/cache/yum
  rm -rf /tmp/scripts
  echo "All done!"
}

setup_baseos
setup_toolings
setup_user_nvim
cleanup
