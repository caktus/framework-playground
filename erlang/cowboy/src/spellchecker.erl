-module(spellchecker).

%% API.
-export([start/0]).

%% API.

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(spellchecker).