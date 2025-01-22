. ./scripts/findFileList.sh
SEARCH_FILE="package.json"
ExclusionList=(
    "artifacts"
    "node_modules"
    "scripts"
    "\.env"
    "\.e"
    "cache")
ExclusionStr="${ExclusionList[@]}"

installNodeModules() {
    local arr=$@
    echo ============== installNodeModules ===================
    for element in $arr
    do
         echo EXECUTING: npm -i $SEARCH_FILE
         # npm -i $SEARCH_FILE
    done
}


installNodeModules() {
    echo "installNodeModules():"

    doubleLine 80
    searchFile=$SEARCH_FILE
    singleLine 80

    getFilePathList $SEARCH_FILE $ExclusionStr
    #myFileList=$(getFilePathList $searchFile)

    sortedUniqueText=$(sortUniqueTextArray $scriptList)
    echo sortedUniqueText=$sortedUniqueText
    dumpArray $sortedUniqueText
    echo
    installNodeModules $sortedUniqueText
}

installNodeModules

