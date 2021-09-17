#!/bin/sh
function load_dotenv(){
	if [ -f .env ]; then
		export $(grep -v '^#' .env | xargs)
	fi
}

function mkcdir ()
{
	mkdir -p -- "$1" &&
		cd -P -- "$1"
}

function virtualenv_venv(){
		virtualenv venv
		source venv/bin/activate
		pip install black ipykernel pylint pip-tools
}
function git_rollback(){
		git reset --soft HEAD~
}
function activate(){
		source venv/bin/activate
}

function merge(){
  local ext
  [ $# -ne 2 ] && echo "Error: Need exactly two args." && return 1
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
