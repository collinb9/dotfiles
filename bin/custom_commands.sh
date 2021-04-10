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
