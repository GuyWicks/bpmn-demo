-- Redis

-- JSON encode/decode

--
-- Transfer nginx variables to local variables
--
local redis_key = ngx.var.redis_key;
local redis_db  = ngx.var.redis_db;

if redis_key == ngx.null then
        ngx.exit( ngx.ERROR )
end

if redis_db == ngx.null then
        redis_db = 0
end

--
-- Return a JSON data structure
--
local table = {
        data = {        
                key = redis_key, 
                value = redis_value
        },
                service = { 
                        status = "OK"
        }
}

ngx.say( redis_key, redis_db ) 
ngx.exit( ngx.HTTP_OK )
