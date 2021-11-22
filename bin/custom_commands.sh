#!/usr/bin/env sh

function load_dotenv(){
	if [ -f .env ]; then
		export $(grep -v '^#' .env | xargs)
	fi
}

function mkcdir () {
	mkdir -p -- "$1" &&
		cd -P -- "$1"
}

function virtualenv_venv(){
    python -m venv venv
    source venv/bin/activate
    python -m pip install --upgrade pip
    python -m pip install black ipykernel pylint pip-tools jedi-language-server cfn-lint
    if [ -f "requirements.txt" ]; then
        python -m pip install -r requirements.txt
    fi
    if [ -f "test_requirements.txt" ]; then
        python -m pip install -r test_requirements.txt
    fi
    if [ -f "dev_requirements.txt" ]; then
        python -m pip install -r dev_requirements.txt
    fi
}
function git_rollback(){
    git reset --soft HEAD~
}
function activate(){
    source venv/bin/activate
}

function merge(){
    local ext
    # [ $# -ne 2 ] && echo "Error: Need exactly two args." && return 1
    [[ ! -r $1 || ! -r $2 ]] && echo "Error: One of the files is not readable." && return 1
    if [[ ${1##*/} =~ '.' || ${2##*/} =~ '.' ]]; then
        [ ${1##*.} != ${2##*.} ] && echo "Error: Files must have same extension." && return 1
         ext=.${1##*.}
    fi
    touch tmp$ext # use empty file as the 'root' of the merge
    cp $1 backup$ext
    git merge-file $2 tmp$ext $1 # will write to file 2
    rm tmp$ext
    echo "Files merged into \"$2\"."
}

function gh_pr_create(){
    branch="${2:-master}"
    echo $branch
    commit_hash=`git log --grep $1 | grep -m 1 commit | awk '{print $2}'`
    echo $commit_hash
    pr_title=` git log --format=%s -n 1 $commit_hash`
    echo title
    echo $pr_title
    pr_body=` git log --format=%b -n 1 $commit_hash`
    # echo body
    # echo $pr_body
    # while true; do
    # read -p "y/n" yn
    echo y/n
    echo "Create a pr against branch=$branch with title: \n$pr_title\n and body:\n$pr_body\n?"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
    gh pr create --title $pr_title --body $pr_body --base $branch
    fi
}

function git_push(){
    git push 2>&1 | grep "git push" | xargs -I {} sh -c {}
}
