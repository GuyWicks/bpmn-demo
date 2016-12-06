-- Redis
local redis = require "resty.redis" 
local red = redis:new()

-- JSON encode/decode
local cjson = require "cjson" 
local cjson2 = cjson.new()

--
-- Transfer nginx variables to local variables
--
local redis_key = ngx.var.redis_key;

--
-- Connect to Redis
--
red:set_timeout( 1000 ) -- 1 sec
local ok, err = red:connect(ngx.var.redis_server, ngx.var.redis_port) 
if not ok then
        ngx.exit( ngx.ERROR )
end

--
-- Try to get the key.
-- If there is an error, return 400
-- If the key cannot be, found return 404
--
local redis_value, err = red:get( redis_key )
if not redis_value then
        ngx.exit( ngx.BAD_REQUEST )
end

if redis_value == ngx.null then
        ngx.exit( ngx.HTTP_NOT_FOUND )
end

--
-- Return a JSON data structure
--
local table = {
        data = {        
                key = redis_key
        },
                service = { 
                        status = "OK"
        }
}

ngx.print( cjson.encode(table) ) 
ngx.exit( ngx.HTTP_OK )
