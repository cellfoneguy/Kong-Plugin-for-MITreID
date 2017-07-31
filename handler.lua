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

	-- Check for required values
	local client_id = h["client_id"]
	local client_secret = h["client_secret"]
	if client_id == nil or client_secret == nil then
		ngx.say("missing id or secret")
		ngx.exit(400)
	end
	local token = h["token"]
	local dest = "nil"
	local data = string.format(
		"client_id=%s&client_secret=%s",
		client_id, client_secret)
	local toAdd = nil

	-- debug set values
	--[[
	local client_id = "03c6f140-ba6e-4a38-917e-61bcc99c75d2"
	local client_secret = "ALpXQvRXcLPFIFqE2dzhZ1tobGBHmvIpg5pKSlHrpD7r8I7ejNfmYY-wFre7Ubx9h6SmoCAqGB0bLFmnhrv08mQ"
	]]

	-- check for token and redirect if present
	---[[
	if token == nil then
		-- Request Token
		dest = "requestToken"
		local scope = "openid"
		local grant_type = "client_credentials"
		toAdd = string.format("&scope=%s&grant_type=%s", scope, grant_type)
		data = data .. toAdd
		ngx.req.set_uri("http://localhost:8080/openid-connect-server-webapp/token")
		--ngx.req.set_uri("https://requestb.in/qq8xjbqq")
		ngx.req.set_method(ngx.HTTP_POST)
	else
		-- Introspect token
		dest = "introspection"
		token = h["token"]
		--token = "eyJraWQiOiJyc2ExIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIwM2M2ZjE0MC1iYTZlLTRhMzgtOTE3ZS02MWJjYzk5Yzc1ZDIiLCJhenAiOiIwM2M2ZjE0MC1iYTZlLTRhMzgtOTE3ZS02MWJjYzk5Yzc1ZDIiLCJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODA4MFwvb3BlbmlkLWNvbm5lY3Qtc2VydmVyLXdlYmFwcFwvIiwiZXhwIjoxNTAxMjgyNjA0LCJpYXQiOjE1MDEyNzkwMDQsImp0aSI6IjU3MmYzYmZiLWM5NzUtNDljZC04YjI4LWMwOGNmMDQ1OTA4ZCJ9.oYRvrcWdMDTVqgLYJMEC8bA6GQyLRgEQJcCBPuQP3gzyZ3JQUk3lYxta9zJbBIfk2W4Mjicg_W0dmWMlG6THyV2YS4gFBqZgV4fL6HaRSi52h7eZdfsoZc1wcczdE46XpWGQlFPKQEj4yenoIBBTTBJaE2MwGxRGZC6ybkFqufkGeI-EaCxPtpf9vfm781AVs5ts-N0B3pUwTejbIOg-MlBnd989BVe4ZlOtue5ltP_c1sjEmLI2L8AWr1hw7W07zm7Rr7n5sJ0PL6GiI8IcW-BfbSwvfwkU5Kh51oVhpAz39notAOcdlZrVIpYmjleLR8mdPznIinWU6gss22OApA"
		toAdd = string.format("&token=%s", token)
		data = data .. toAdd
		ngx.req.set_uri("http://localhost:8080/openid-connect-server-webapp/introspect")
		--ngx.req.set_uri("https://requestb.in/qq8xjbqq")			
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