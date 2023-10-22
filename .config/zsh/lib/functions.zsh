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
