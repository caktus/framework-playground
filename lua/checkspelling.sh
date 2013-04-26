#!/bin/sh

# Gets a word to spellcheck as first arg on command line
# Prints "true" if the word is spelled correctly, otherwise "false"

# Skip first line of output, look at beginning of next line
line=$(echo "$1" | hunspell -a|tail -n +2)
case "$line" in
  [*+-]*) echo "true" ;;
  *) echo "false" ;;
esac
