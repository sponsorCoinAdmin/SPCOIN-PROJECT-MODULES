
alias initSpCoinEnv="export CLONE_PROJECT_LOG=CLONE_PROJECT.log ;
              	     export ACTIVE_PROJECT_NAME=SPCOIN-PROJECT-MODULES ;
	             export ACTIVE_PROJECT_ROOT=\$PWD ;
	             export ACTIVE_PROJECT_HOME=\$PWD/\$ACTIVE_PROJECT_NAME"

alias clearSpCoinEnv="export CLONE_PROJECT_LOG= ;
                      export ACTIVE_PROJECT_NAME= ;
		      export ACTIVE_PROJECT_ROOT= ;
		      export ACTIVE_PROJECT_HOME= "

alias echoSpCoinEnv="echo CLONE_PROJECT_LOG=\$CLONE_PROJECT_LOG;
                     echo ACTIVE_PROJECT_NAME=\$ACTIVE_PROJECT_NAME ;
	             echo ACTIVE_PROJECT_ROOT=\$ACTIVE_PROJECT_ROOT ;
	             echo ACTIVE_PROJECT_HOME=\$ACTIVE_PROJECT_HOME "

alias cloneproj="clear; cloneSponsorCoinProjects;"
alias cdspc="cd ~/spcoin/\$SPCOIN-PROJECT-MODULES"

installGitModules() {
    echo "############# INSTALL GIT MODULES ############"
    echo "IN ROOT DIRECTORY: $ACTIVE_PROJECT_ROOT"
    echo "EXECUTING: git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$ACTIVE_PROJECT_NAME.git";
    git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$ACTIVE_PROJECT_NAME.git;
    echo "EXECUTING: . ./scripts/setupEnvVars.sh";
    cd $ACTIVE_PROJECT_NAME
    . ./scripts/setupEnvAliases.sh;
    echo "ACTIVE_PROJECT_NAME : $ACTIVE_PROJECT_NAME"
    echo "ACTIVE_PROJECT_ROOT : $ACTIVE_PROJECT_ROOT"
    echo "ACTIVE_PROJECT_HOME : $ACTIVE_PROJECT_HOME"
}

installSecurityKeys() {
    echo "############# INSTALL LOCAL SECURITY KEYS ############"
    cd $ACTIVE_PROJECT_HOME
    echo "EXECUTING: cp ~/SECURITY/.env spcoin-hardhat-contract-access-test -f;"
    cp ~/SECURITY/.env spcoin-hardhat-contract-access-test -f;
    echo "EXECUTING: cp ~/SECURITY/.env.local ./spcoin-nextjs-front-end"
    cp ~/SECURITY/.env.local ./spcoin-nextjs-front-end -f;
    echo "ACTIVE_PROJECT_NAME : $ACTIVE_PROJECT_NAME"
    echo "ACTIVE_PROJECT_ROOT : $ACTIVE_PROJECT_ROOT"
    echo "ACTIVE_PROJECT_HOME : $ACTIVE_PROJECT_HOME"
}

installAliases() {
    echo ############## INSTALL PROJECecho ############T ALIASES ############"
    echo HERE 1 current dir = $PWD
    echo "EXECUTING: . ./scripts/setupEnvAliases.sh";
    echo HERE 2 current dir = $PWD
    . ./scripts/setupEnvAliases.sh;
    echo HERE 3 current dir = $PWD
    setroot
    echo HERE 4 current dir = $PWD
    cd $ACTIVE_PROJECT_HOME
    echo HERE 5 current dir = $PWD
}

installNodeModules() {
    echo ############# INSTALL NODE MODULES ############"
    cd $ACTIVE_PROJECT_HOME
    echo "EXECUTING: . ./scripts/installNodeModules.sh";
    . ./scripts/installNodeModules.sh
    echo "EXECUTING: setroot";
    setroot
}

cloneSponsorCoinProjects() {
    initSpCoinEnv       2>&1 | tee    $CLONE_PROJECT_LOG
    installGitModules   2>&1 | tee -a $CLONE_PROJECT_LOG
    installSecurityKeys 2>&1 | tee -a $CLONE_PROJECT_LOG
    installAliases      2>&1 | tee -a $CLONE_PROJECT_LOG
    installNodeModules  2>&1 | tee -a $CLONE_PROJECT_LOG
}
