#!/bin/bash

ACTION=$1

case "$ACTION" in
    example)
        lua ./example.lua
        ;;
    test)
        lua ./run_tests.lua
        ;;
    install)
        LIBS_PATH="./lib"
        REPOSITORIES=$(cat ./libs.txt)

        for REPOSITORY in "${REPOSITORIES[@]}"
        do
            echo "----- Installing $REPOSITORY -----"
            LIB_NAME=$(echo $REPOSITORY | cut -d'/' -f2 | cut -d'.' -f1)
            LIB_PATH="$LIBS_PATH/$LIB_NAME"

            if [ ! -d "$LIB_PATH" ]; then
                git clone $REPOSITORY $LIB_PATH
            fi
            echo ""
        done

        ;;
    *)
        echo "Usage: $0 {test|example|install}"
        exit 1
esac
