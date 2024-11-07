#!/bin/bash

OPTION=$1
FLAG=$2
LUA=lua5.4

if [ "$OPTION" = "b" ]; then
  $LUA ./benchmarks/init.lua
elif [ "$OPTION" = "t" ]; then 
  $LUA tests/init.lua
elif [ "$OPTION" = "i" ]; then 
    if [ "$FLAG" = "force" ]; then
      rm -rf lua_modules
    fi

    mkdir lua_modules
    cd lua_modules

    git clone https://github.com/YagoCrispim/moontest.git
    rm -rf ./moontest/.git

    git clone https://github.com/slembcke/debugger.lua.git
    mv debugger.lua debugger
    rm -rf ./debugger/.git
    
    cd --
else
  echo "[ERROR]: Option not found"
  echo "Usage: cli.sh b[enchmark]|t[est]|i[nstall]"
fi

