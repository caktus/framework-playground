Cowboy Example
================================================================================

This is a Cowboy example of the spell checker service. To run it requires::

    Cowboy 0.8.X

..note::

    Cowboy requires Erlang R15 or higher which is not included in Ubuntu 12.04.
    You can install R15B1 from ppa:markdlavin/erlang.

This can be installed with `rebar <https://github.com/basho/rebar>`_ via::

    ./rebar get-deps

Then you can build the application::

    ./rebar compile

And start the application::

    ./start.sh