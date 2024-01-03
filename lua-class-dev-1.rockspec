package = "lua-class"
version = "v1.0.0"
source = {
   url = "git+ssh://git@github.com/YagoCrispim/lua-class.git",
   tag = "v1.0.0"
}
description = {
   summary = " Classes in Lua",
   detailed = "Emulates class behavior",
   homepage = "https://github.com/YagoCrispim/lua-class",
   license = "MIT",
   labels = {
	"class", "inheritance", "namespace", "oop", "object"
   },
    maintainer = "yagoc <yagocrispim.r.s@gmail.com>"
}
dependencies = {
   "lua ~> 5.4"
}
build = {
   type = "none",
   modules = {
      class = "class.lua"
   }
}
