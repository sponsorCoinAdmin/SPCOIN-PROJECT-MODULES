echo "EXECUTING . ~/.spCoinEnv/.e"
. ~/.spCoinEnv/.a


sethome() {
    setenv ~/
}

export ACTIVE_PROJECT_NAME=SPCOIN-PROJECT-MODULES
export ACTIVE_PROJECT_HOME=$PWD/$ACTIVE_PROJECT_NAME

setenv() {
    export ACTIVE_PROJECT_NAME=$1
    export ACTIVE_PROJECT_HOME=/c/Users/Robin/spcoin/SPCOIN-PROJECT-MODULES/$ACTIVE_PROJECT_NAME
    export ACTIVE_ENV_PATH=/c/Users/Robin/spcoin/SPCOIN-PROJECT-MODULES/spcoin-hardhat-contract-access-test/.e
    export ACTIVE_SCRIPTS_PATH=$ACTIVE_PROJECT_HOME/scripts
    export ACTIVE_LOGS_PATH=$ACTIVE_PROJECT_HOME/logs
    . $ACTIVE_ENV_PATH/.a
}
clearshellenv() {
    echo CLEARING SHELL_PROFILE = ~$SHELL_PROFILE
    sed -i '/ACTIVE_ENV_FILE_PATH/d' ~/$SHELL_PROFILE
    sed -i '/ACTIVE_PROJECT_HOME/d' ~/$SHELL_PROFILE
    sed -i '/ROOT_ENV_CONFIG/d' ~/$SHELL_PROFILE
}

clearSpCoinEnv() {
    export ACTIVE_PROJECT_PARENT=
    export ACTIVE_PROJECT_HOME=
    export CLONE_PROJECT_LOG=
}

initSpCoinEnv() {
    export ACTIVE_PROJECT_PARENT=$PWD ;
    export SPCOIN_ROOT_PATH=$ACTIVE_PROJECT_PARENT
    export ACTIVE_PROJECT_HOME=$SPCOIN_ROOT_PATH/$ACTIVE_PROJECT_NAME
    export CLONE_PROJECT_LOG=$ACTIVE_PROJECT_PARENT/CLONE_PROJECT.log
}

echoSpCoinEnv() {
   echo ACTIVE_PROJECT_NAME=$ACTIVE_PROJECT_NAME
   echo ACTIVE_PROJECT_PARENT=$ACTIVE_PROJECT_PARENT
   echo SPCOIN_ROOT_PATH=$SPCOIN_ROOT_PATH
   echo ACTIVE_PROJECT_HOME=$ACTIVE_PROJECT_HOME
   echo CLONE_PROJECT_LOG=$CLONE_PROJECT_LOG
}

evalInstallScript () {
    local scriptName=$1
    echo "========================== $scriptName ==============================="
    shift;  # will remove first arg from the "$@"
    local "CURR_DIR=$PWD"
    echo CURR_DIR: $CURR_DIR
    echo EXECUTING: "cd $ACTIVE_PROJECT_HOME"
    cd $ACTIVE_PROJECT_HOME
    echo "IN PROJECT ROOT DIRECTORY: $PWD"
    echo "EXECUTING INSTALL SCRIPT: eval $@"
    eval "$@"
    cd $CURR_DIR
    echo RESTORED DIRECTORY LOCATION: $CURR_DIR
}

installGitModules() {
    echo "=========================== initSpCoinEnv ================================"
    initSpCoinEnv
    echoSpCoinEnv
    echo "========================= installGitModules =============================="
    echo PROJECT PARENT DIR: $PWD
    script="git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$ACTIVE_PROJECT_NAME.git"
    echo "EXECUTING INSTALL SCRIPT: eval $script"
    eval "$script"
}

installSecurityKeys() {
    script="cp -f ~/spcoin/SECURITY/.env spcoin-hardhat-contract-access-test"
    evalInstallScript "installSecurityKeys" $script
    script="cp -f ~/spcoin/SECURITY/.env.local ./spcoin-nextjs-front-end"
    evalInstallScript "installSecurityKeys" $script
}

installRootAliases() {
    script=". ./scripts/setupEnvAliases.sh"
    evalInstallScript "installAliases" $script
}

setRootEnv() {
    echo ACTIVE_ENV_FILE_PATH=$ACTIVE_PROJECT_HOME/.env/.e
    export ACTIVE_ENV_FILE_PATH=$ACTIVE_PROJECT_HOME/.env/.e
    . $ACTIVE_ENV_FILE_PATH
}



installNodeModules() {
    script=". ./scripts/installNodeModules.sh"
    evalInstallScript "installNodeModules" $script
}

cloneSponsorCoinProjects() {
    clearshellenv       2>&1 
    initSpCoinEnv       2>&1
    echoSpCoinEnv       2>&1 | tee    $CLONE_PROJECT_LOG
    installGitModules   2>&1 | tee -a $CLONE_PROJECT_LOG
    installSecurityKeys 2>&1 | tee -a $CLONE_PROJECT_LOG
    installRootAliases  2>&1 | tee -a $CLONE_PROJECT_LOG
    installNodeModules  2>&1 | tee -a $CLONE_PROJECT_LOG
    setRootEnv          2>&1 | tee -a $CLONE_PROJECT_LOG
}

