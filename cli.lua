local function get_del_cmd()
  if package.config:sub(1, 1) == "\\" then
    return 'rmdir'
  end
  return 'rm -rf'
end

local option = arg[1]
local flag = arg[2]
local lua = 'lua'
local delcmd = get_del_cmd()

if option == 'b' then
  os.execute(lua .. ' ./benchmarks/init.lua lib')
  os.execute(lua .. ' ./benchmarks/init.lua oop_one')
  os.execute(lua .. ' ./benchmarks/init.lua oop_two')
elseif option == 't' then
  os.execute(lua .. ' tests/init.lua')
elseif option == 'i' then
  if flag == 'force' then
    os.execute(delcmd .. ' lua_modules')
  end

  os.execute('git clone https://github.com/YagoCrispim/moontest.git ./lua_modules/moontest')
  os.execute(delcmd .. ' ./lua_modules/moontest/.git')

  os.execute('git clone https://github.com/slembcke/debugger.lua.git ./lua_modules/debugger')
  os.execute(delcmd .. ' ./lua_modules/debugger/.git')
else
  print('[ERROR]: Option not found')
  print('Usage: cli.lua b[enchmark]|t[est]|i[nstall]')
end
