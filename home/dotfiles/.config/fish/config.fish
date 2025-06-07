### EXPORT ###
# Supresses fish's intro message
set fish_greeting

# set aliases

alias config="git --git-dir=$HOME/git_repos/dotfiles/ --work-tree=$HOME $argv"
alias nixosconf="git --git-dir=$HOME/git_repos/nixos/.git --work-tree=$HOME/git_repos/nixos/ $argv"


# restart emacs client
alias emacsd='systemctl --user restart --now emacs'

#
# gentoo
alias emergesync='sudo emerge --sync'
function emergeinstall
    sudo snapper -c root create --description "install package $argv"
    sudo emerge -avgDN $argv
end
function emergeupdate
    sudo snapper -c root create --description "system update" -c number
    sudo emerge -avugDN --read-news @world
end
function emergeclean
    sudo emerge --ask --depclean
    sudo eclean distfiles
    sudo eclean packages
    sudo eclean-kernel -n 2
end

# nixos
function nixosupdate
    pushd $HOME/git_repos/nixos/
    nix flake update
    sudo nixos-rebuild switch --flake $HOME/git_repos/nixos#$argv
    popd
end
alias nixdiff='nix profile diff-closures --profile /nix/var/nix/profiles/system'

#arch
function pacupdate
    sudo pacman -Syu
    # automatically perform diff if new config files are available
    sudo DIFFPROG='nvim -d' pacdiff
end
alias pacinstall='sudo pacman -Syu'

alias pacremove='sudo pacman -Rsn'
function pacclean
    # see https://wiki.archlinux.org/title/system_maintenance
    # check if services are not starting
    systemctl --failed

    echo "Search and remove orphaned packages"
    sudo pacman -Qdtq | sudo pacman -Rns -

    echo "cleanup the package cache (keep the last version)"
    sudo paccache -rk1

    echo "remove all uninstaled packages from the package cache"
    sudo paccache -ruk0
end

#tumbleweed
alias zypperrefresh='sudo zypper refresh'
function zypperdup
    sudo zypper refresh
    sudo zypper dup --no-recommends
end
alias zypperclean='sudo zypper clean'

#set new global path for npm packages
set NPM_PACKAGES "$HOME/npm-packages"
set PATH $PATH $NPM_PACKAGES/bin
set MANPATH $NPM_PACKAGES/share/man $MANPATH  

if status is-interactive
    # Commands to run in interactive sessions can go here
end
