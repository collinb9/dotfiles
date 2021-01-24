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
