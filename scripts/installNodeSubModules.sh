exeIfDirExists() {
    DIRECTORY=$1
    COMMAND=$2
    local CURR_DIR=$PWD
    echo "CURRENT DIRECTORY : $PWD"
    if [ -d "$DIRECTORY" ]; then
        echo "INSTALLING MODULES IN: $DIRECTORY"
        echo "EXECUTING            : $COMMAND"
        eval $COMMAND
    else 
        echo "***ERROR: DIRECTORY $DIRECTORY NOT FOUND"
        echo "***ERROR: COMMAND $COMMAND NOT EXECUTED" 
    fi
    cd $CURR_DIR
}

clear
echo ===== START INSTALLING SPONSORCOIN NPM MODULES in $(PWD) =====
echo HERE 1
exeIfDirExists $SPCOIN_BE_PATH "npm i"
echo HERE 2
exeIfDirExists $SPCOIN_FE_PATH "npm i"
echo HERE 3
exeIfDirExists . "npm i"
echo HERE 4 $PWD
echo ===== FINISHED INSTALLING SPONSORCOIN NPM MODULES in $(PWD) =====
