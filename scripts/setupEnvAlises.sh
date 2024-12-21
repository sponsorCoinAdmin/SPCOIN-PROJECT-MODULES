clear
export ROOT_PROJECT_DIR=$PWD

#SET UP BASH ENVIRONMENT
echo "set -o vi"                                                          | tee -a ~/.bashrc
echo ". $ROOT_PROJECT_DIR/.env/.e"                                        | tee -a ~/.bashrc

# ROOT PROJECT ENVIRONMENT SETUP
echo 'SET UP ROOT_ENV_DIR CONFIGURATION FILE: ".env/.e "'
echo "export ROOT_PROJECT_NAME=$(basename $PWD)/"                         | tee  a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_PROJECT_DIR=$ROOT_PROJECT_DIR/"                         | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_SCRIPTS_DIR=$ROOT_PROJECT_DIR/scripts/"                 | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_ENV_DIR=$ROOT_PROJECT_DIR/.env/"                        | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export ROOT_LOGS_DIR=$ROOT_ENV_DIR/logs/"                           | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export SPCOIN_PROJECT_FG_DIR=spcoin-nextjs-front-end/"              | tee -a $ROOT_PROJECT_DIR/.env/.e
echo "export SPCOIN_PROJECT_BG_DIR=spcoin-hardhat-contract-access-tests/" | tee -a $ROOT_PROJECT_DIR/.env/.e
echo ". $ROOT_ENV_DIR/.a"                                                 | tee -a $SPCOIN_ENV_DIR/.e

. ~/.bashrc



# echo ". $ROOT_ENV_DIR/.a" | tee -a $ROOT_ENV_DIR/.e
# echo m | tee -a $ROOT_ENV_DIR/.e

# echo "Adding Sponsor Coin startup configuration Files to bootstrap file Project Root Parent"

# # echo "export ACTIVE_PROJECT=$ROOT_PROJECT_NAME" | tee -a $ROOT_PROJECT_DIR/.env/.e
# echo ". $ROOT_PROJECT_DIR/\$ACTIVE_PROJECT/.e/.e" | tee -a $ROOT_PROJECT_DIR/.env/.e

# ###############################################################################################:q
# export PH=$ROOT_PROJECT_DIR/\$ROOT_PROJECT_NAME
# echo "export ROOT_PROJECT_DIR=$PH" | tee -a $ROOT_PROJECT_DIR/.env/.e
# echo "export ROOT_ENV_DIR=$PH/.env" | tee -a $ROOT_PROJECT_DIR/.env/.e
# echo "export ROOT_SCRIPTS_DIR=$$PH/scripts" | tee -a $ROOT_PROJECT_DIR/.env/.e
# echo "export ROOT_LOGS_DIR=$$PH/.env/logs" | tee -a $ROOT_PROJECT_DIR/.env/.e
# ###############################################################################################

# echo "Adding Sponsor Coin startup configuration Files to bootstrap file ~/.bashrc"
# echo ". $ROOT_PROJECT_DIR/.env/.e" | tee -a ~/.bashrc

# echo "Starting The Project Environment"
# . $ROOT_ENV_DIR/.e

# cd $ROOT_PROJECT_DIR
# echo "***IMPORTANT *** Please ensure the '.env' file is configured for proper operations"
