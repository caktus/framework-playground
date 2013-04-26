Lua example web service
=======================

Prequisites
-----------

Ubuntu packages
    Install thusly::

        sudo apt-get install hunspell libhunspell-dev lua5.1 liblua5.1-0-dev cmake xavante

luaspell
    Build from github and put the module where lua can find it::

        git clone git://github.com/mkottman/luaspell.git
        cd luaspell
        cmake .
        make
        cd ..
        cp luaspell/spell.so .

Running
-------

Simple::

    lua server.lua
