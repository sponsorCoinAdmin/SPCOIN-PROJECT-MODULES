echo ========================= START INSTALLING NPM MODULES in $(PWD) =====================================
echo START INSTALLING NPM Modules in $(PWD)
CURR_DIR=$(PWD)
cd $SPCOIN_BE_PATH
npm i 
cd $CURR_DIR
cd $SPCOIN_FE_PATH
npm i 
cd $CURR_DIR
echo FINISHED INSTALLING NPM Modules in $(PWD)
echo ======================== FINISHED INSTALLING NPM MODULES in $(PWD) ===================================
