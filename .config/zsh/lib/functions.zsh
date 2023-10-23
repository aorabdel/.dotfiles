function zsh_add_file ()
{
    [ -f "${ZSH_CONFIG_DIR}/$1" ] && source "${ZSH_CONFIG_DIR}/$1" || echo "$1 not found"
}

function zsh_add_plugin ()
{
    local plugin_name=$(echo $1 | cut -d "/" -f 2)
    local plugin_dir="plugins"
    mkdir -p "$ZSH_CONFIG_DIR/$plugin_dir"

    if [ -d "$ZSH_CONFIG_DIR/$plugin_dir/$plugin_name" ]; then
        zsh_add_file "$plugin_dir/$plugin_name/$plugin_name.plugin.zsh"
        zsh_add_file "$plugin_dir/$plugin_name/$plugin_name.zsh"
    else
        git clone "https://github.com/$1.git" "{$ZSH_CONFIG_DIR}/${plugin_dir}/${plugin_name}"
    fi
}

function tmux_add_plugin ()
{
    local tmux_config_dir="$HOME/.config/tmux"
    local plugin_name=$(echo $1 | cut -d "/" -f 2)
    local plugin_dir="plugins"
    mkdir -p "$tmux_config_dir/$plugin_dir"

    if [ ! -d "$tmux_config_dir/$plugin_dir/$plugin_name" ]; then
        git clone "https://github.com/$1.git" "$tmux_config_dir/$plugin_dir/$plugin_name"

    fi
}

function zsh_set_prompt()
{
    # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    autoload -U colors && colors
    setopt PROMPT_SUBST

    zsh_add_file lib/git.zsh
    zsh_add_file prompts/$1.zsh-theme
}

function update_nvim()
{
    local RED=$(tput setaf 1)
    local GREEN=$(tput setaf 2)
    local NC=$(tput sgr0)
    local BOLD=$(tput bold)

    local install_nightly=true 
    local re_version='s/.*refs\/tags\/(.*)/\1/'
    local re_annotation='s/\^\{\}//'
    local repo_url="https://github.com/neovim/neovim"
    local latest_stable_ver=$(git ls-remote --tags ${repo_url} | tail -1 | sed -r ${re_version} | sed -r ${re_annotation})
    local nvim_version=${latest_stable_ver}
    $install_nightly && nvim_version="nightly"
    local url="${repo_url}/releases/download/${nvim_version}/nvim.appimage"

    local output=$(curl -L -w http_code=%{http_code} ${url} -o /tmp/nvim)
    local http_code=$(echo "${output}" | sed -r 's/.*\http_code=//')
    local error_message=$(cat /tmp/nvim)

    if [[ ${http_code} == 200 ]]; then
        chmod +x /tmp/nvim;
        sudo mv /tmp/nvim /usr/local/bin;
        printf "${GREEN}Neovim Nightly has been updated successfully!${NC}\n"
    else
        printf "${RED}Neovim Nightly has NOT been updated! ERROR: ${error_message}${NC}\n"
    fi
}

function update_clangd()
{
    local RED=$(tput setaf 1)
    local GREEN=$(tput setaf 2)
    local NC=$(tput sgr0)
    local BOLD=$(tput bold)

    local repo_url="https://github.com/clangd/clangd/"
    local latest_url=$(curl -Ls -o /dev/null -w %{url_effective} ${repo_url}/releases/latest)
    local latest_stable_version=$(basename ${latest_url})
    local url="https://github.com/clangd/clangd/releases/download/${latest_stable_version}/clangd-linux-${latest_stable_version}.zip"
    local output=$(curl -L -w http_code=%{http_code} ${url} -o /tmp/clangd)
    local http_code=$(echo "${output}" | sed -r 's/.*\http_code=//')
    local error_message=$(cat /tmp/clangd)

    if [[ ${http_code} == 200 ]]; then
        unzip /tmp/clangd -d /tmp
        local extracted_dir="/tmp/clangd_${latest_stable_version}"
        local clangd_bin="${extracted_dir}/bin/clangd"
        local clangd_lib="${extracted_dir}/lib/clang"
        chmod +x ${clangd_bin};

        # # Clean existing installation
        rm -rf /usr/local/bin/clangd
        rm -rf /usr/local/lib/clang

        sudo mv ${clangd_bin} /usr/local/bin/;
        sudo mv ${clangd_lib} /usr/local/lib/;

        # Cleanup /tmp/ files
        rm -rf /tmp/clangd
        rm -rf ${extracted_dir}

        printf "${GREEN}clangd has been updated successfully to ${latest_stable_version}!${NC}\n"
    else
        printf "${RED}clangd has NOT been updated! ERROR: ${error_message}${NC}\n"
    fi
}