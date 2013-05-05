-module(spellchecker_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/check", check_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8000}], [
        {env, [{dispatch, Dispatch}]}
    ]),
    spellchecker_sup:start_link().

stop(_State) ->
    ok.
