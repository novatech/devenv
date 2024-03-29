#!/bin/bash
set -o nounset # error when referencing undefined variable

USR="${1:-azwan}"

declare -A tooling_repos
tooling_repos=(
  ['neovim/neovim']=0.8.1
  ['dandavison/delta']=0.15.1
  ['tree-sitter/tree-sitter']=0.20.7
  ['mvdan/sh']=3.5.1
  ['jesseduffield/lazygit']=0.36.0
  ['koalaman/shellcheck']=0.8.0
)

# get latest release from GitHub api
# extract tag_name": "v0.7.0" and pluck json value
function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases?per_page=2" |
    grep '"tag_name":.*"v' | head -1 |
    sed -E 's/.*"v([^"]+)".*/\1/'
}

function refresh_tooling_repo() {
  for i in "${!tooling_repos[@]}"; do
    latest_version=$(get_latest_release "$i")
    tooling_repos[$i]=${latest_version:-${tooling_repos[$i]}}
    echo "[$i]=${tooling_repos[$i]}"
  done
}

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
    python \
    pip \
    npm \
    unzip \
    xz \
    fontconfig \
    sudo
  npm i -g yarn
  pip install --upgrade pip virtualenv
  sed -i 's/^LANG=.*/LANG="en_US.utf8"/' /etc/locale.conf
  /usr/sbin/useradd -m "${USR}"
  echo "%${USR} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers
}

function setup_toolings() {
  mkdir -p "/home/${USR}/.config/"
  mkdir -p "/home/${USR}/devtools/bin"

  curl -fL "https://github.com/neovim/neovim/releases/download/v${tooling_repos['neovim/neovim']}/nvim-linux64.tar.gz" | tar -zxvf - -C /tmp/scripts
  mv "/tmp/scripts/nvim-linux64/" "/home/${USR}/devtools/nvim"

  curl -fL "https://github.com/dandavison/delta/releases/download/${tooling_repos['dandavison/delta']}/delta-${tooling_repos['dandavison/delta']}-x86_64-unknown-linux-gnu.tar.gz" | tar -zxvf - -C /tmp/scripts
  cp "/tmp/scripts/delta-${tooling_repos['dandavison/delta']}-x86_64-unknown-linux-gnu/delta" "/home/${USR}/devtools/bin/delta"

  curl -fL "https://github.com/tree-sitter/tree-sitter/releases/download/v${tooling_repos['tree-sitter/tree-sitter']}/tree-sitter-linux-x64.gz" | zcat - >/tmp/scripts/tree-sitter && chmod +x /tmp/scripts/tree-sitter
  cp "/tmp/scripts/tree-sitter" "/home/${USR}/devtools/bin/tree-sitter"

  curl -fL "https://github.com/mvdan/sh/releases/download/v${tooling_repos['mvdan/sh']}/shfmt_v${tooling_repos['mvdan/sh']}_linux_amd64" >/tmp/scripts/shfmt && chmod +x /tmp/scripts/shfmt
  cp "/tmp/scripts/shfmt" "/home/${USR}/devtools/bin/shfmt"

  curl -fL "https://github.com/jesseduffield/lazygit/releases/download/v${tooling_repos['jesseduffield/lazygit']}/lazygit_${tooling_repos['jesseduffield/lazygit']}_Linux_x86_64.tar.gz" | tar -zxvf - -C /tmp/scripts
  cp "/tmp/scripts/lazygit" "/home/${USR}/devtools/bin"

  curl -fL "https://github.com/koalaman/shellcheck/releases/download/v${tooling_repos['koalaman/shellcheck']}/shellcheck-v${tooling_repos['koalaman/shellcheck']}.linux.x86_64.tar.xz" | tar -xJv -C /tmp/scripts
  cp "/tmp/scripts/shellcheck-v${tooling_repos['koalaman/shellcheck']}/shellcheck" "/home/${USR}/devtools/bin"

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

echo "USR=${USR}"
refresh_tooling_repo

(return 0 2>/dev/null) && echo Script Sourced || {
  set -o errexit # exit when command fails
  setup_baseos
  setup_toolings
  setup_user_nvim
  cleanup
}
