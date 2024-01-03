package = "lua-class"
version = "v1.0.0"
source = {
   url = "git+ssh://git@github.com/YagoCrispim/lua-class.git"
}
description = {
   summary = " Classes in Lua",
   detailed = "Emulates class behavior",
   homepage = "https://github.com/YagoCrispim/lua-class",
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      class = "class.lua",
      class_test = "class_test.lua",
      example = "example.lua"
   }
}
