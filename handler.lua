-- Extending the Base Plugin handler is optional, as there is no real
-- concept of interface in Lua, but the Base Plugin handler's methods
-- can be called from your child implementation and will print logs
-- in your `error.log` file (where all logs are printed).
local BasePlugin = require "kong.plugins.base_plugin"
local FooHandler = BasePlugin:extend()

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instanciate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function FooHandler:new()
	FooHandler.super.new(self, "foo")
end

function FooHandler:init_worker(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.init_worker(self)

	-- Implement any custom logic here
end

function FooHandler:certificate(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.certificate(self)

	-- Implement any custom logic here
end

function FooHandler:rewrite(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.rewrite(self)

	-- Implement any custom logic here
end

function FooHandler:access(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.access(self)

	ngx.req.read_body()
	local h = ngx.req.get_post_args()
	local uri = ngx.var.request_uri

	-- Check for required values
	local client_id = h["client_id"]
	local client_secret = h["client_secret"]
	if client_id == nil or client_secret == nil then
		ngx.say("missing id or secret")
		ngx.exit(400)
	end
	local dest = "nil"
	local data = string.format(
		"client_id=%s&client_secret=%s",
		client_id, client_secret)
	local toAdd = nil

	---[[
	if uri == "/token" then
		-- Request Token
		dest = "requestToken"
		local scope = "openid"
		local grant_type = "client_credentials"
		toAdd = string.format("&scope=%s&grant_type=%s", scope, grant_type)
		data = data .. toAdd
		ngx.req.set_uri("http://localhost:8080/openid-connect-server-webapp/token")
		ngx.req.set_method(ngx.HTTP_POST)
	elseif uri == "/introspect" then
		-- Introspect token
		dest = "introspection"
		token = h["token"]
		toAdd = string.format("&token=%s", token)
		data = data .. toAdd
		ngx.req.set_uri("http://localhost:8080/openid-connect-server-webapp/introspect")
		ngx.req.set_method(ngx.HTTP_GET)
	end
	ngx.req.set_header("Destination", dest)
	--]]

	-- Set data params	
	ngx.req.set_uri_args(data)

	-- Choose URI
	--ngx.req.set_uri("https://requestb.in/qq8xjbqq")

end

function FooHandler:header_filter(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.header_filter(self)

	-- Implement any custom logic here
end

function FooHandler:body_filter(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.body_filter(self)

	-- Implement any custom logic here
end

function FooHandler:log(config)
	-- Eventually, execute the parent implementation
	-- (will log that your plugin is entering this context)
	FooHandler.super.log(self)

	-- Implement any custom logic here
end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return FooHandler