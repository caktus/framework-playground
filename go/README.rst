Go Example
==========

This is an example of the spell checker service written in Go. To run it requires
an installation of Go.

To run the server::

    go run spellserver.go

By default the server will listen on port 4000 and use /usr/share/dict/words (plus
"razzmatazz" the dictionary of valid words. You can pass in an alterante port and
word file like so::

    go run spellserver.go 8000 /usr/share/dict/british-english

You cannot override "razzmatazz" being considered a valid word.
