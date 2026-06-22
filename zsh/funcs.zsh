function p() {
    argv=("$@")
    if [ $# -eq 0 ]
    then
        echo "For example [p nil go], search nil keywords in go type files."
        return
    fi
    cmd="grep -iRl '$1' ."

    for ((i=2; i <= $#; i++)); do
            cmd=$cmd" --include \"*.${argv[i-1]}\" "
        done
    if [ -e ~/.grep-exclude ]
    then
        while read exclude
        do
            cmd=$cmd" --exclude="$exclude
        done < ~/.grep-exclude
    fi

    if [ -e ~/.grep-exclude-dir ]
    then
        while read excludedir
        do
            cmd=$cmd" --exclude-dir="$excludedir
        done < ~/.grep-exclude-dir
    fi
    eval "$cmd"
}

function x() {
    exit
}

function f(){
    file=$1
    if [ $# -eq 0 ]
          then
              echo "No arguments supplied"
              return
    fi
    if [ -z "${file##*.vue}" ] ;then
        find . -not -name "*.json" -not -name "*.js" \
        -not -path "./.git/*" \
        -not -path "./.logs/*" \
        -iname "*$1"
    elif [ -z "${file##*.php}" ] ;then
        find . -not -name "*.png" -not -name "*.jpg" -not -name "*.gif" \
        -not -name "*.json" -not -name "*.js" -not -name "*.vue" \
        -not -path "./.git/*" \
        -not -path ".logs/*" \
        -not -path "./vendor/*" \
        -iname "*$1"
    elif [ -z "${file##*.js}" ] ;then
        find . -not -name "*.png" -not -name "*.jpg" -not -name "*.gif" \
        -not -name "*.php" -not -name "*.json" -not -name "*.vue" \
        -not -path "./.git/*" \
        -not -path ".logs/*" \
        -not -path "./bi/*" \
        -iname "*$1"
    else
        find . -not -name "*.png" -not -name "*.jpg" -not -name "*.gif" \
        -not -path "./.git/*" \
        -not -path "./logs/*" \
        -iname "*$1*"
    fi
    return
    ext=$2
    if [ $ext="" ]
          then
              ext="php"
    fi
    if [ $2="php" ] ;then
        find . -not -name "*.png" -not -name "*.jpg" -not -name "*.gif" \
        -not -name "*.json" -not -name "*.js" -not -name "*.vue" \
        -not -path ".git/*" \
        -not -path ".logs/*" \
        -not -path "./wwwroot/manager/web/*" \
        -not -path "./standapi/*" \
        -not -path "./bi/*" \
        -iname "*$1*"
    elif [ $2="js" ] ;then
        find .  -not -name "*.php" -not -name "*.bak" ! -path "./.git/*" ! -path "./logs/*" -iname "*$1*"
    elif [ $2="vue" ] ;then
        find .  -not -name "*.php" -not -name "*.js" ! -path "./.git/*" ! -path "./logs/*" -iname "*$1."
    elif [ $2="be" ] ;then
        find .  -not -name "*.json" -not -name "*.js" -not -name "*.vue" ! -path "./.git/*" ! -path "./logs/*" ! -path "./wwwroot/manager/web/*" -iname "*$1*"
    else [ $2="fe" ] 
        find .  -not -name "*.php" -not -name "*.bak" ! -path "./.git/*" ! -path "./logs/*" -iname "*$1*"
    fi
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

#screen
function sn(){
    session=$1
    if [ -z $session ]
        then
            screen -ls
        else
            screen -rD $session
    fi
}

# map v to /vim/vim/vi

function v() {
    local editor
    if editor=$(command -v nvim); then
        echo "$editor $@"
        sleep 0.5
        "$editor" "$@"
    elif editor=$(command -v vim); then
        echo "$editor $@"
        sleep 0.5
        "$editor" "$@"
    elif editor=$(command -v vi); then
        echo "$editor $@"
        sleep 0.5
        "$editor" "$@"
    else
        echo "No suitable text editor found."
        return 1
    fi
}

# edit modified files
function vm() {
    local editor
    local modified_files=()
    while IFS= read -r line; do
      modified_files+=("$line")
    done < <(git diff --name-only --diff-filter=M)

    if editor=$(command -v nvim); then
        echo "$editor ${modified_files[*]}"
        sleep 0.5
        "$editor" "${modified_files[@]}"
    elif editor=$(command -v vim); then
        echo "$editor ${modified_files[*]}"
        sleep 0.5
        "$editor" "${modified_files[@]}"
    elif editor=$(command -v vi); then
        echo "$editor ${modified_files[*]}"
        sleep 0.5
        "$editor" "${modified_files[@]}"
    else
        echo "No suitable text editor found."
        return 1
    fi
}


function c(){
    if [ "e" = $1 ]; then
        crontab -e
    else
        crontab -l
    fi
}

#synctax check for modified PHP files
function gcps(){
    git ls-files --modified | xargs -L1 php -l
    git ls-files --others --exclude-standard | xargs -L1 php -l
}
