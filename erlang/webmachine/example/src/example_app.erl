%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the example application.

-module(example_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for example.
start(_Type, _StartArgs) ->
    example_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for example.
stop(_State) ->
    ok.
