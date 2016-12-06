--#
--# Redis - Set key/value pair
--# GDW 2016/11
--#

-- Redis
local redis  = require "resty.redis" 
local red    = redis:new()

-- JSON encode/decode
local cjson  = require "cjson" 
local cjson2 = cjson.new()

--
-- Transfer nginx variables to local variables
--
local redis_key   = ngx.var.redis_key;
local redis_value = ngx.var.redis_value;
local redis_db    = ngx.var.redis_db;

if redis_key == ngx.null then
        ngx.exit( ngx.ERROR )
end

if redis_value == ngx.null then
        ngx.exit( ngx.ERROR )
end

if redis_db == ngx.null then
        redis_db = 0
end


--
-- Connect to Redis
--
red:set_timeout( 1000 ) -- 1 sec
local ok, err = red:connect(ngx.var.redis_server, ngx.var.redis_port) 
if not ok then
        ngx.exit( ngx.ERROR )
end

--
-- Try to set the key.
-- If there is an error, return 400
--
local ok, err = red:select( redis_db )
local ok, err = red:set( redis_key, redis_value )
if not ok then
        ngx.exit( ngx.BAD_REQUEST )
end

--
-- Return a JSON data structure
--
local table = {
        data = {        
                key = redis_key, 
                value = redis_value,
                redis_db = redis_db

        },
                service = { 
                        status = "OK",
        }
}

ngx.print( cjson.encode(table) ) 
ngx.exit( ngx.HTTP_OK )
