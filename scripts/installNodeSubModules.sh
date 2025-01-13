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

clear
echo HERE 1 $PWD
exeIfDirExists $SPCOIN_BE_PATH "npm i"
echo HERE 2 $PWD
cd $SPCOIN_BE_PATH
echo HERE 3 $PWD
npm i
echo HERE 4 $PWD
cd ..
echo HERE 5 $PWD
exeIfDirExists $SPCOIN_BE_PATH "npm i"
echo HERE 6 $PWD
cd $SPCOIN_FE_PATH
echo HERE 7 $PWD
npm i 
echo HERE 8 $PWD
cd ..
echo HERE 9 $PWD
echo FINISHED INSTALLING NPM Modules in $(PWD)
echo HERE 10 $PWD
echo ===== FINISHED INSTALLING NPM MODULES in $(PWD) =====
echo HERE 11 $PWD
