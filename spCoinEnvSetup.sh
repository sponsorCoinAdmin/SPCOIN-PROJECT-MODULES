# Requires git setup
export SPONSOR_COIN_ROOT_DIR=$PWD
export SPONSOR_COIN_DIR=spcoin-contracts-js-access
export SPONSOR_COIN_DEV_DIR=spCoinEnvSetup;
echo "DownLoading Sponsor Coin Development Envirement from gitHub"
git clone git@github.com:sponsorCoinAdmin/$SPONSOR_COIN_DIR.git
cd $SPONSOR_COIN_DIR
echo "Installing the Node Libraries"
npm i
echo "Configuring SponsorCoin Environment"
export SPONSOR_COIN_HOME=$SPONSOR_COIN_ROOT_DIR/$SPONSOR_COIN_DIR
export SPONSOR_COIN_ENV=$SPONSOR_COIN_HOME/$SPONSOR_COIN_DEV_DIR
export SPONSOR_COIN_LOGS=$SPONSOR_COIN_ENV/logs

# echo "Adding startup configuration Files to bootstrap file ~/.baschrc"
# echo "export SPONSOR_COIN_HOME=$SPONSOR_COIN_HOME" | tee -a ~/.bashrc
# echo "export SPONSOR_COIN_ENV=$SPONSOR_COIN_ENV" | tee -a ~/.bashrc
# echo "export SPONSOR_COIN_LOGX=$SPONSOR_COIN_LOGS" | tee -a ~/.bashrc

echo "Adding startup configuration Files to Sponsor Coin environment setup file $SPONSOR_COIN_ENV/.e"
echo "export SPONSOR_COIN_HOME=$SPONSOR_COIN_HOME" | tee -a $SPONSOR_COIN_ENV/.e
echo "export SPONSOR_COIN_ENV=$SPONSOR_COIN_ENV" | tee -a $SPONSOR_COIN_ENV/.e
echo "export SPONSOR_COIN_LOGX=$SPONSOR_COIN_LOGS" | tee -a $SPONSOR_COIN_ENV/.e

echo "Adding sponsor coin startup configuration Files to bootstrap file ~/.baschrc"
echo ". "$SPONSOR_COIN_ENV"/.e" | tee -a ~/.bashrc
. $SPONSOR_COIN_ENV/.e
echo "***IMPORTANT *** Please ensure the '.env' file is configured for proper operations"
