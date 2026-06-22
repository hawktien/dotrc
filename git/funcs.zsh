function gs(){
    iecho "git status"
    git status
}

unalias grs
function grs(){
    git remote show |
    while IFS= read -r upstream; do
        git remote show $upstream
    done
}

# git pull from paramete specified remote or all remotes
unalias gl
function gl(){
    branch=`git branch --show-current`
    [ $? -ne 0 ] && return
    if [ ! -z $1 ]
        then
            for remote in "$@"
            do
                iecho "git pull $remote $branch"
                git pull $remote $branch
            done
            return
    fi

    git remote show |
    while IFS= read -r remote; do
        iecho "git pull $remote $branch"
        git pull $remote $branch
    done
}

function iecho() {
    echo "----------------------------------------"
    echo "****** $1 ******"
    echo "----------------------------------------"
}

#git commit
function gci() {
    message=$1
    [ -z $message ] && message='nocommit'
    iecho "git commit -m $message"
    git commit -m $message
}

# git push to paramete specified remote or all remotes

function gh() {
    if [ ! -d ".git" ]; then  
        echo "Current directory was not a git repository."
        exit 1  
    fi

    branch=$(git branch --show-current 2>/dev/null)
    if [ -z "$branch" ]; then
        echo "Error: Not on any branch."
        return 1
    fi

    git remote show |
    while IFS= read -r remote; do
        echo "git push $remote $branch"
        git push $remote $branch
    done
}


function gfr(){
    branch=$1
    if [ $branch="" ] 
        then
          return "No arguments supplied"
    fi
    remote=`git remote show`
    git fetch $remote $branch
}

# git add
unalias ga
function ga(){
    if [[ ! -z $1 ]]
        then
            iecho "git add $1"
            git add $1
    else
        while read file; do
            iecho "git add $file"
            git add $file
        done < <(git ls-files --modified)

        while read file; do
            iecho "git add $file"
            git add $file
        done < <(git ls-files --others --exclude-standard)
    fi
}

# git diff
function gd(){
    if [ -f $1 ]
    then
        git diff $1
    else
        git diff
    fi
}

function ggg(){
    ga && gci && gl && gh
}

