. ./scripts/findFileList.sh
CURR_DIR=$PWD
SEARCH_FILE="package.json"
ExclusionList=(
    "artifacts"
    "node_modules"
    "scripts"
    "\.env"
    "\.e"
    "cache")
ExclusionStr="${ExclusionList[@]}"

installArrayModules() {
    local arr=$@
    echo =========================================== installNodeModules ===============================================
    echo EXECUTION DIRECTORY: $CURR_DIR
    doubleLine 110
    for element in $arr
    do
         parentdir="$(dirname "$element")"
	 echo EXECUTING: cd $parentdir
	 cd $parentdir
         echo IN DIRECTORY $PWD
         echo EXECUTING installNodeModules: npm i
         npm i
	 echo EXECUTING: cd $CURR_DIR
	 cd $CURR_DIR
	 singleLine 110
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
    echo  sortedUniqueText=$sortedUniqueText
    installArrayModules $sortedUniqueText
}

installNodeModules
