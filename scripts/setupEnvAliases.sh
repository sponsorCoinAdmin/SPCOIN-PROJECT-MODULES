echo ==== SETTING UP ENVIRONMENT VARIABLES ====
export ACTIVE_PROJECT_NAME=$(basename $PWD)
export ACTIVE_ROOT_DIR="$PWD"
#export ACTIVE_PROJECT_HOME=$ACTIVE_PROJECT_ROOT/$ACTIVE_PROJECT_NAME
export ACTIVE_PROJECT_HOME=$PWD
export ACTIVE_ENV_DIR=/.env

# INITIALIZATION FUNCTION FOR BASHRC SETUP
insertOnce() { 
    if  grep -q "$1" "$2" ; then
        echo 'ERROR: LINE:"'$1'" EXISTS IN FILE:"'$2'"' ; 
    else
        echo 'INSERTING: LINE:"'$1'" IN FILE:"'$2'"' ; 
        echo $1 | tee -a $2
    fi
}

createNewEnvironmentFile() {
    export ACTIVE_PROJECT_HOME=$1
    export ACTIVE_PROJECT_NAME=$2
    export ACTIVE_ENV_DIR=$3
    export ACTIVE_ENV_PATH=$ACTIVE_PROJECT_HOME$ACTIVE_ENV_DIR
    export ACTIVE_ENV_FILE_PATH=$ACTIVE_ENV_PATH/.e
    echo "#SPCOIN PROJECT CONFIGURATION FILE: $ACTIVE_PROJECT_NAME"                      | tee    $ACTIVE_ENV_FILE_PATH
    echo "#SPCOIN ENVIRONMENT CONFIGURATION SETUP SCRIPT: $ACTIVE_ENV_FILE_PATH"         | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export ACTIVE_ENV_FILE_PATH=$ACTIVE_ENV_FILE_PATH"                             | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export ACTIVE_PROJECT_NAME=$ACTIVE_PROJECT_NAME"                               | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export ACTIVE_PROJECT_HOME=$ACTIVE_PROJECT_HOME"                               | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export ACTIVE_ENV_PATH=$ACTIVE_ENV_PATH"                                       | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export ACTIVE_SCRIPTS_PATH=\$ACTIVE_PROJECT_HOME/scripts"                      | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export ACTIVE_LOGS_PATH=\$ACTIVE_PROJECT_HOME/logs"                            | tee -a $ACTIVE_ENV_FILE_PATH

    echo "export SPCOIN_ROOT_NAME=\$ACTIVE_PROJECT_NAME"                                 | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export SPCOIN_ROOT_PATH=\$ACTIVE_PROJECT_HOME"                                 | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export SPCOIN_BE_PATH=\$SPCOIN_ROOT_PATH/spcoin-hardhat-contract-access-test"  | tee -a $ACTIVE_ENV_FILE_PATH
    echo "export SPCOIN_FE_PATH=\$SPCOIN_ROOT_PATH/spcoin-nextjs-front-end"              | tee -a $ACTIVE_ENV_FILE_PATH

    echo ". \$ACTIVE_ENV_PATH/.a"                                                        | tee -a $ACTIVE_ENV_FILE_PATH
    echo "m"                                                                             | tee -a $ACTIVE_ENV_FILE_PATH
}

#SET UP BASH ENVIRONMENT
createNewEnvironmentFile $ACTIVE_PROJECT_HOME $ACTIVE_PROJECT_NAME $ACTIVE_ENV_DIR
insertOnce "set -o vi" ~/.bashrc;
insertOnce "###################### SPONSOR COIN ENVIRONMENT START SETTINGS #############################"  ~/.bashrc
insertOnce "export ROOT_ENV_CONFIG=$ACTIVE_ENV_FILE_PATH" ~/.bashrc;
insertOnce ". \$ROOT_ENV_CONFIG" ~/.bashrc;
sed -i '/ACTIVE_PROJECT_HOME/d' ~/.bashrc;
sed -i '/ACTIVE_ENV_FILE_PATH/d' ~/.bashrc;

# echo "export ACTIVE_PROJECT_HOME=$ACTIVE_PROJECT_HOME" | tee -a ~/.bashrc
echo "cd \$ACTIVE_PROJECT_HOME"                      | tee -a ~/.bashrc

#RUN THE ENVIRONMENT SETUP
echo "EXECUTING: . $ACTIVE_ENV_FILE_PATH"
. $ACTIVE_ENV_FILE_PATH
