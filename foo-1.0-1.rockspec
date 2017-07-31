package = "Foo"
version = "1.0-1"
source = {
   url = "..." -- We don't have one yet
}
description = {
   summary = "An example for the LuaRocks tutorial.",
   detailed = [[
      This is an example for the LuaRocks tutorial.
      Here we would put a detailed, typically
      paragraph-long description.
   ]],
   homepage = "http://...", -- We don't have one yet
   license = "MIT/X11" -- or whatever you like
}
dependencies = {
   "lua >= 5.1, < 5.4"
   -- If you depend on other rocks, add them here
}
build = {
   type = "builtin",
   modules = {
      handler = "handler.lua",
      schema = "schema.lua"
   }
}