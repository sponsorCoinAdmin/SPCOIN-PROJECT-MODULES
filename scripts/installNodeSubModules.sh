exeIfDirExists() {
    DIRECTORY=$1
    COMMAND=$2
    echo "FROM ROOT DIR        : $PWD"
    if [ -d "$DIRECTORY" ]; then
        echo "INSTALLING MODULES IN: $DIRECTORY"
        echo "EXECUTING            : $COMMAND"
    else 
        echo "***ERROR: DIRECTORY $DIRECTORY not found"
        echo "***ERROR: COMMAND $COMMAND NOT EXECUTED" 
    fi
}

exeIfDirExists $SPCOIN_BE_PATH "npm i"
cd $SPCOIN_BE_PATH
npm i
cd ..
exeIfDirExists $SPCOIN_BE_PATH "npm i"
cd $SPCOIN_FE_PATH
npm i 
cd ..
echo FINISHED INSTALLING NPM Modules in $(PWD)
echo ===== FINISHED INSTALLING NPM MODULES in $(PWD) =====
