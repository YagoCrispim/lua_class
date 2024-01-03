package = "lclass"
version = "1.0.0-1"
source = {
   url = "git+https://github.com/YagoCrispim/lua-class.git",
   tag = "v1.0.0"
}
description = {
   summary = " Classes in Lua",
   detailed = "Emulates class behavior",
   homepage = "https://github.com/YagoCrispim/lua-class",
   license = "MIT",
    maintainer = "yagoc <yagocrispim.r.s@gmail.com>"
}
dependencies = {
   "lua ~> 5.4"
}
build = {
   type = "none",
   install = {
      lua = {
         "class.lua"
      }
   }
}
