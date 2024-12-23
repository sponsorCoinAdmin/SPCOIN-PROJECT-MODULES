# SPCOIN-PROJECT-MODULES

POPULAR COMMANDS
alias ve="vi $ROOT_ENV_DIR/.e;e"
alias vm="vi $ROOT_ENV_DIR/.m;m"

alias cdbg="cd $PROJECT_ROOT/$SPCOIN_BG_PATH"
alias cdfg="cd $PROJECT_ROOT/$SPCOIN_FG_PATH"
alias cdscr="cd $ROOT_SCRIPTS_DIR"
alias cddep="cdscr; cd deployments"
alias cdhh="cdbg"

alias sethh="clear; cdhh"
alias vbrc="vi ~/.bashrc"
alias vg="sethh; vi .gitignore"
alias vs="code"

# NPM SETUP
alias npmi="npm install @sponsorcoin/spcoin-access-modules"
alias npmp="npm publish"


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