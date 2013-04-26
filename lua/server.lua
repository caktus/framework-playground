require "xavante"

local function err_400 (req, res)
	res.statusline = "HTTP/1.1 400 Invalid request"
	res.headers ["Content-Type"] = "text/html"
	res.content = string.format ([[
<!DOCTYPE HTML>
<HTML><HEAD>
<TITLE>400 Invalid request/TITLE>
</HEAD><BODY>
<H1>Invalid request</H1>
The requested URL %s was not a valid request.<P>
</BODY></HTML>]], req.built_url);
	return res
end

local function check_spelling(word)
    -- return true if word is spelled okay
   local cmd = string.format("./checkspelling.sh %s", word)
   local output = io.popen(cmd, "r"):read()
   return (output == 'true') and true or false
end

-- handle /check?q=xxxx requests
local function check_handler (req, res)
	if req.cmd_mth ~= "GET" and req.cmd_mth ~= "HEAD" then
		return xavante.httpd.err_405 (req, res)
	end
    params = xavante.httpd.getparams(req)
    if (params == nil) or (params['q'] == nil) then
       return err_400(req, res)
    end
    word = params['q']
    result = check_spelling(word)
    res.headers ["Content-Type"] = "text/json"
    if result then
       res.content = '{"valid": true}'
    else
       res.content = '{"valid": false}'
    end
    return res
end

local simplerules = {
   -- /check[parms] handled by check_handler
    {
      match = "/check$",
      with = check_handler
    },
    -- anything else gets a 404
}


-- Define the server
xavante.HTTP{
    server = {host = "*", port = 8000},
    defaultHost = {
    	rules = simplerules
    },
}

-- start it
xavante.start()
