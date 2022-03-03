#!/bin/bash

#source app/bin/activate
export FLASK_APP=hello
export FLASK_ENV=development

flask run --host=0.0.0.0
