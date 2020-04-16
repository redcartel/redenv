#! /bin/bash

cd ~/wk

if [ -f package.json ]; then
	yarn start
elif [ -f wsgi.py ]; then
	python -m virtualenv venv
	export FLASK_DEBUG=1
	flask run
elif [ -f run.sh ]; then
	bash run.sh
fi
