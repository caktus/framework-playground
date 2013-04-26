%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(example_resource).
-export([init/1, content_types_provided/2, allowed_methods/2, malformed_request/2, to_json/2, check_spelling/1, readfile/1]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, Ctx) ->
    {[{"application/json", to_json}], ReqData, Ctx}.

allowed_methods(ReqData, Ctx) ->
    {['GET'], ReqData, Ctx}.

malformed_request(ReqData, Ctx) ->
    Q = wrq:get_qs_value("q", ReqData),
    {Q == undefined, ReqData, Ctx}.

to_json(ReqData, Ctx) ->
    Q = wrq:get_qs_value("q", ReqData),
    Valid = check_spelling(Q),
    Result = [{valid, Valid}],
    {mochijson:encode({struct, Result}), ReqData, Ctx}.

check_spelling(Word) ->
    WordSet = sets:from_list(readfile("/usr/share/dict/words")),
    sets:is_element(Word, WordSet).

readfile(FileName) ->
    {ok, Binary} = file:read_file(FileName),
    string:tokens(erlang:binary_to_list(Binary), "\n").