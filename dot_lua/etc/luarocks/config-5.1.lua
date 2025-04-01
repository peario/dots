-- LuaRocks configuration

rocks_trees = {
   { name = "user", root = home .. "/.luarocks" };
   { name = "system", root = "/Users/peario/.lua" };
}
variables = {
   LUA_DIR = "/Users/peario/.lua";
   LUA_INCDIR = "/Users/peario/.lua/include";
   LUA_BINDIR = "/Users/peario/.lua/bin";
   LUA_VERSION = "5.1";
   LUA = "/Users/peario/.lua/bin/lua";
}
external_deps_dirs = { "/opt/homebrew" }
