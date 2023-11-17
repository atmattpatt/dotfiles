#!/bin/bash

#link() {
    #target="$HOME/.$1"
    #source="$DOTFILES_PATH/$1"

    #if [ -d "$source" ] && [ -L "$target" ]; then
        #unlink "$target"
    #fi

    #ln -vfs "$source" "$target"
#}

#get_font() {
    #target="$HOME/.fonts/$1"
    #github=$2

    #if [ ! -f "$target" ]; then
        #curl -s -o "$target" "$github"
    #fi
#}

#link tmux.conf
#link vim
#link vimrc

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TMP_DIR="$SCRIPT_DIR/tmp"

DRY_RUN=0
FORCE=0
VERBOSE=0
QUIET=0
INSTALL_MODE="symlink"
HOME_DIR="$HOME"

AVAILABLE_TARGETS=(git ohmyzsh packages)

FMT_BOLD='\033[1m'
FMT_ERROR='\033[1;4;31m'
FMT_WARNING='\033[1;4;38;5;208m'
FMT_INFO='\033[92m'
FMT_COMMAND='\033[38;5;244m'
FMT_DRY_RUN='\033[38;5;226m'
FMT_INPUT='\033[38;5;75m'
FMT_RESET='\033[0m'

print_error () {
    echo -n -e "${FMT_ERROR}ERROR${FMT_RESET}: "
    echo -e "$@"
}

print_warning () {
    echo -n -e "${FMT_WARNING}WARNING${FMT_RESET}: "
    echo -e "$@"
}

print_info () {
    echo -n -e "${FMT_INFO}$1${FMT_RESET}"
    shift
    echo -e " $@"
}

run () {
    local command_retval=0

    echo -n -e "${FMT_COMMAND}>> $@${FMT_RESET}"

    if [ $DRY_RUN -eq 1 ]; then
        echo -e " ${FMT_DRY_RUN}(dry run)${FMT_RESET}"
        return
    fi

    echo ""

    sh -c "export HOME=\"$HOME_DIR\" && $*"
    command_retval=$?

    if [ $command_retval -ne 0 ]; then
        print_error "Command exited with status code $command_retval"
        exit 3
    fi
}

brew_install_packages () {
    local brew_cmd="brew"

    if [ $VERBOSE -eq 1 ]; then
        brew_cmd="$brew_cmd --verbose"
    fi

    if [ $QUIET -eq 1 ]; then
        brew_cmd="$brew_cmd --quiet"
    fi

    brew_cmd="$brew_cmd install"

    if [ $FORCE -eq 1 ]; then
        brew_cmd="$brew_cmd --overwrite"
    fi

    print_info "Installing packages" "$@"
    run "$brew_cmd" "$@"
}

install_packages () {
    case "$OSTYPE" in
        darwin*)
            brew_install_packages $@
            ;;
        *)
            error "Unsupported operating system $OSTYPE"
            exit 2
            ;;
    esac
}

download () {
    local wget_cmd="wget"

    if [ $VERBOSE -eq 1 ]; then
        wget_cmd="$wget_cmd --verbose"
    fi

    if [ $QUIET -eq 1 ]; then
        wget_cmd="$wget_cmd --quiet"
    fi

    print_info "Downloading file" "$1"
    run "$wget_cmd" -O "$TMP_DIR/$2" "$1"
}

install_file () {
    local copy_cmd="cp"

    if [ $INSTALL_MODE == "symlink" ]; then
        copy_cmd="ln -s"
    fi

    if [ $FORCE -eq 1 ]; then
        copy_cmd="$copy_cmd -f"
    fi

    if [ $VERBOSE -eq 1 ]; then
        copy_cmd="$copy_cmd -v"
    fi

    run "$copy_cmd" "$SCRIPT_DIR/$1" "$HOME_DIR/.$1"
}

show_help () {
    echo -e "${FMT_BOLD}Usage${FMT_RESET}: $0 [OPTIONS] [TARGET ...]

${FMT_BOLD}NEW MACHINE? RUN THIS:${FMT_RESET}
    $0 --all

${FMT_BOLD}OPTIONS${FMT_RESET}
    -n, --dry-run       Don't actually make any changes
    -f, --force         Forcefully overwrite existing settings
    -v, --verbose       Run all commands verbosely
    -q, --quiet         Run all commands quietly
    -A, --all           Run all targets
    -l, --symlink       Symlink config files to this repo (default behavior)
    -C, --hard-copy     Copy config files instead of symlinking
    --home-dir          Override the directory for making changes
                        (default $HOME)

${FMT_BOLD}TARGET${FMT_RESET}
    Available targets: ${AVAILABLE_TARGETS[@]}"
}

target_git () {
    print_info "Installing Git configuration"
    install_file "gitconfig"
    install_file "gitignore_global"
}

target_ohmyzsh () {
    local zsh_install_script="install_ohmyzsh.sh"
    download "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" "install_ohmyzsh.sh"

    if [ -d "$HOME_DIR/.oh-my-zsh" ]; then
        if [ $FORCE -eq 1 ]; then
            run rm -rf "$HOME_DIR/.oh-my-zsh"
        else
            run mv "$HOME_DIR/.oh-my-zsh" "$HOME_DIR/.oh-my-zsh.old-$(date -Iseconds)"
        fi
    fi

    if [ -L "$HOME_DIR/.zshrc" ]; then
        run unlink "$HOME_DIR/.zshrc"
    fi

    if [ -L "$HOME_DIR/.p10k.zsh" ]; then
        run unlink "$HOME_DIR/.p10k.zsh"
    fi

    print_info "Running Oh-My-Zsh installer"
    export RUNZSH=no
    run sh "$TMP_DIR/$zsh_install_script"

    print_info "Installing Powerlevel10k theme"
    run git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$HOME_DIR/.oh-my-zsh/custom/themes/powerlevel10k"

    print_info "Installing .zshrc"
    run mv "$HOME_DIR/.zshrc" "$HOME_DIR/.zshrc.default"
    install_file "zshrc"
    install_file "p10k.zsh"
    install_file "oh-my-zsh/custom/plugins/mattpatt"
}

target_packages () {
    local oldforce=$FORCE

    # Always install git with force
    FORCE=1
    install_packages git
    FORCE=$oldforce

    install_packages \
        bat \
        dog \
        duf \
        dust \
        exa \
        fd \
        fzf \
        git-delta \
        httpie \
        jless \
        jq \
        ripgrep \
        tmux \
        wget \
        nvim
}

main () {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    until [ -z "$1" ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -n|--dry-run)
                DRY_RUN=1
                shift
                ;;
            -f|--force)
                FORCE=1
                shift
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -q|--quiet)
                QUIET=1
                shift
                ;;
            -l|--symlink)
                INSTALL_MODE="symlink"
                shift
                ;;
            -C|--hard-copy)
                INSTALL_MODE="copy"
                shift
                ;;
            --home-dir)
                shift
                HOME_DIR=$( cd -- "$1" &> /dev/null && pwd )
                shift
                ;;
            -A|--all)
                break
                ;;
            -*|--*)
                print_error "Unknown option ${FMT_INPUT}$1${FMT_RESET}"
                show_help
                exit 1
                ;;
            *) break
        esac
    done

    mkdir -p "$TMP_DIR"

    until [ -z "$1" ]; do
        case "$1" in
            -A|--all)
                target_packages
                target_ohmyzsh
                target_git
                break
                ;;
            git)
                target_git
                shift
                ;;
            ohmyzsh)
                target_ohmyzsh
                shift
                ;;
            packages)
                target_packages
                shift
                ;;
            -*|--*)
                print_warning "Ignoring option ${FMT_INPUT}$1${FMT_RESET}"
                shift
                ;;
            *)
                print_error "Unknown target ${FMT_INPUT}$1${FMT_RESET}"
                echo "Available targets: ${AVAILABLE_TARGETS[@]}"
                exit 1
                ;;
        esac
    done
}

main $@
