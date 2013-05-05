-module(check_handler).

-export([init/3]).
-export([content_types_provided/2]).
-export([allowed_methods/2]).
-export([malformed_request/2]).
-export([to_json/2]).
-export([terminate/3]).
-export([check_spelling/1]).

init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

content_types_provided(Req, State) ->
    {[{<<"application/json">>, to_json}], Req, State}.

allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

malformed_request(Req, State) ->
    {Q, Req2} = cowboy_req:qs_val(<<"q">>, Req),
    {Q == undefined, Req2, State}.

to_json(Req, State) ->
    {Q, Req2} = cowboy_req:qs_val(<<"q">>, Req),
    Valid = check_spelling(binary_to_list(Q)),
    Result = {[{valid, Valid}]},
    Body = jiffy:encode(Result),
    {Body, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.

check_spelling(Word) ->
    case re:run(Word, "[a-zA-Z]+") of
        {match, _} -> Command = string:join(["echo",  Word , "|", "enchant", "-a", "-l"], " "),
            Result = lists:nth(2, string:tokens(os:cmd(Command), "\n")),
            lists:sublist(Result, 1) == "*";
        nomatch -> false
    end.