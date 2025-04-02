# SPCOIN-PROJECT-MODULES

POPULAR COMMANDS
alias ve="vi $ROOT_ENV_DIR/.e;e"
alias vm="vi $ROOT_ENV_DIR/.m;m"

alias cdbe="cd $PROJECT_ROOT/$SPCOIN_BE_PATH"
alias cdfe="cd $PROJECT_ROOT/$SPCOIN_FE_PATH"
alias cdscr="cd $ROOT_SCRIPTS_DIR"
alias cddep="cdscr; cd deployments"
alias cdhh="cdbe"

alias sethh="clear; cdhh"
alias vbrc="vi ~/.bashrc"
alias vg="sethh; vi .gitignore"
alias vs="code"

# CLONING PROJECTS WITH ASSOCIATED SUBMODULES

## PREREQUSITES prior to running the Installation script
create a directory called <b>SECURITY</b>.
In this directory, create two files. <b>.env</b> and <b>.env.local</b>
<b>.env ~ </b> Required for back end processing
<b>.env.local ~ </b> Required for nextjs fronr nen processing

### .env (A short Example File)
#### Copy these file entries the .env file located at the root of the server app
the .env is typically used in hardhat back end testing project spcoin-hardhat-contract-access-test
Use the following entries as sample entries required to run the project
```env
# HARDHAT LOCALHOST ( Your hardhat base url domain:port)
HARDHAT="http://127.0.0.1:8545"

# SIGNER ACCOUNT ACCESS KEYS (Sellect a valid account from a wallet like Metamask)
WALLET_ADDRESS="(Put your WALLET account public address Key Here)"
WALLET_SECRET="(Put your WALLET account private address Key Here)"

# ETHERSCAN API KEY
ETHERSCAN_API_KEY="(Put your Etherscan Key Here)"

SAMPLE KEYS which you must get from Alchemy (https://auth.alchemy.com/)
# ALCHEMY NETWORK KEYS
GOERLI_ALCHEMY_TEST_URL="(Put your GOERLI ALCHEMY public Key Here)"
SEPOLIA_ALCHEMY_TEST_URL="(Put your SEPOLIA ALCHEMY public Key Here)"
MAINNET_ALCHEMY_TEST_URL="(Put your MAINNET ALCHEMY public Key Here)"
POLYGON_ALCHEMY_TEST_URL="(Put your POLYGON ALCHEMY public Key Here)"

SAMPLE KEYS which you must get from Infura (www.infura.ioInfura)
# INFURA NETWORK KEYS
GOERLI_INFURA_TEST_URL="(Put your GOERLI INFURA public Key Here)"
SEPOLIA_INFURA_TEST_URL="(Put your SEPOLIA INFURA public Key Here)"
MAINNET_INFURA_TEST_URL="(Put your MAINNET INFURA public Key Here)"
```



### .env.local (Example File)


## Install and run the following script
cloneSpCoinProjects() {<BR>
    clear<BR>
    export ACTIVE_ROOT_DIR=$PWD<BR>
    export ACTIVE_PROJECT_NAME=SPCOIN-PROJECT-MODULES<BR>
    git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$ACTIVE_PROJECT_NAME.git<BR>
    echo "EXECUTING cd $ACTIVE_PROJECT_NAME"<BR>
    cd $ACTIVE_PROJECT_NAME<BR>
    echo "EXECUTING: . ./scripts/installNodeSubModules.sh"<BR>
    . ./scripts/installNodeSubModules.sh<BR>
    echo "EXECUTING: . ./scripts/setupAliases.sh"<BR>
    . ./scripts/setupEnvAliases.sh<BR>
    cp ~/SECURITY/.env spcoin-hardhat-contract-access-test -f<BR>
    cp ~/SECURITY/.env.local ./spcoin-nextjs-front-end -f<BR>
    setroot<BR>
}

## EX1. Cloning SPCOIN-PROJECT-MODULES with all submodules
### 1. Run the above shell script in a command terminal
### 2. Execute the schipt in the directorywhere you wish to install the project by typing
cloneSpCoinProjects\<enter>

## EX2. Cloning SPCOIN-PROJECT-MODULES with all submodules using your shell startup script
### 1. Install above shell script in your shell startup script.
For example: if using bash install the above script in .bashrc.
### 3. Restart your command terminal to reload the startup script.
### 2. Execute the schipt in the directorywhere you wish to install the project by typing
cloneSpCoinProjects\<enter>

# Note:
the above script installs all the spcoin projects and installs the Nod Package Modules

# HARD HAT TESTING
alias remixd="nohup node $PROJECT_HOME/node_modules/@remix-project/remixd/src/bin/remixd.js 2>&1 > $LOGS_DIR/remixd.out &"
alias hhcompile="sethh; npx hardhat compile"

alias hhdeploy=hhdeploypolygon
alias hhsize="sethh; npx hardhat size-contracts"
alias hhtest="sethh; reset;clear; npx hardhat test 2>&1 | tee ./test.out/hhtest.out"
alias hhrun="sethh;  npx hardhat node"

#DEPLOY TOKENS
alias deploytokens="sethh; . ./scripts/deployTokens.sh"
alias deployapollo="sethh; . ./scripts/deployments/deployApollo.sh"
alias deploychicken="sethh; . ./scripts/deployments/deployChickenCoin.sh"
alias deployspcoin="sethh; . ./scripts/deployments/deploySPCoin.sh"
alias deployusdc="sethh; . ./scripts/deployments/deployUSDC.sh"
alias deployusdt="sethh; . ./scripts/deployments/deployUSDT.sh"
alias deployweth="sethh; . ./scripts/deployments/deployWeth.sh"

alias hhnode="sethh; npx hardhat node  2>&1 > $LOGS_DIR/hhnode.out"
alias hhlocal="sethh; npx hardhat node; deploytokens"
alias forkmainnet="sethh; npx hardhat node --fork https://mainnet.infura.io/v3/08b06e80980b4c1c9d9d450f4f71607d &"
alias forkpolygon="sethh; npx hardhat node --fork https://polygon-mainnet.infura.io/v3/08b06e80980b4c1c9d9d450f4f71607d &"
alias forksepolia="sethh; npx hardhat node --fork https://sepolia.infura.io/v3/08b06e80980b4c1c9d9d450f4f71607d &"
alias starthh="$SCRIPTS_DIR/startLocalHardHat.sh &"
