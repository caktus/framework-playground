#!/bin/sh
erl -pa ebin deps/*/ebin -s spellchecker \
    -eval "io:format(\"Point your browser at http://localhost:8000~n\")."