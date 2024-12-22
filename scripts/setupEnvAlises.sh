clear
insertOnce() { 
    # echo AAAA 0 = $0 1 = $1 2 = $2
    if  grep -q "$1" "$2" ; then
        echo 'ERROR: LINE:"'$1'" EXISTS IN FILE:"'$2'"' ; 
    else
        echo 'INSERTING: LINE:"'$1'" IN FILE:"'$2'"' ; 
        echo $1 | tee -a $2
    fi
}

export ROOT_PROJECT_DIR=$PWD

#SET UP BASH ENVIRONMENT
# echo "set -o vi"                                                          | tee -a ~/.bashrc
# echo ". $ROOT_PROJECT_DIR/.env/.e"                                        | tee -a ~/.bashrc

# ROOT PROJECT ENVIRONMENT SETUP
echo 'SET UP ROOT_ENV_DIR CONFIGURATION FILE: ".env/.e "'
echo "export ROOT_PROJECT_NAME=$(basename $PWD)"                 | tee  a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_PROJECT_DIR=$ROOT_PROJECT_DIR"                 | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_SCRIPTS_DIR=$ROOT_PROJECT_DIR/scripts"         | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_ENV_DIR=$ROOT_PROJECT_DIR/.env"                | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_LOGS_DIR=$ROOT_PROJECT_DIR/.env/logs"          | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export SPCOIN_FG_DIR=spcoin-nextjs-front-end"              | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export SPCOIN_BG_DIR=spcoin-hardhat-contract-access-tests" | tee -a $ROOT_PROJECT_DIR/.env/.e
echo ". $ROOT_ENV_DIR/.a"                                        | tee -a $ROOT_PROJECT_DIR/.env/.e

. $ROOT_PROJECT_DIR/.env/.e

# SET THE PROJECT ROOT ENVIRONMENT
insertOnce "set -o vi" ~/.bashrc;
insertOnce ". $ROOT_PROJECT_DIR/.env/.e" ~/.bashrc;

echo "Starting The Project Environment"
. $ROOT_PROJECT_DIR/.env/.e
