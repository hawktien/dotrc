function x() {
    exit
}

function f(){
    find . ! -path "./.git/*" ! -path "./vendor/*" ! -path "./logs/*" -iname "*$1*"
}

function h() {
    if [ $# -eq 0 ]
    then
            history | tail -100
    else
            history | tail -$1
    fi
}

function t(){
    p1=$1
    if [ -d $p1 ]
    then
        tree $p1 | more
    elif [ -z "${1//[1-9]}" ]
    then
        tree -L $1 | more
    else
        tree -L 1 | more
    fi
}

function sn(){
    session=$1
    if [ -z $session ]
        then
            screen -ls
        else
            screen -rD $session
    fi
}

# map v to neovim
function v() {
    local editor
    if editor=$(command -v nvim); then
        "$editor" "$@"
    fi
}

# list modified files
function gm() {
    local modified_files=()
    while IFS= read -r line; do
      modified_files+=("$line")
    done < <(git diff --name-only --diff-filter=M)
    echo "${modified_files[*]}"
}


function c(){
    if [ "e" = $1 ]; then
        crontab -e
    else
        crontab -l
    fi
}

#synctax check for modified PHP files
function cps(){
    git ls-files --modified | xargs -L1 php -l
    git ls-files --others --exclude-standard | xargs -L1 php -l
}

function dt(){
  echo "$(date +'%Y%m%d.%H%M%S')"
}
