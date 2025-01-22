. ./scripts/findFileList.sh
INSTALL_SCRIPT="scripts/installNodeModules.sh"
ExclusionList=(
    "artifacts"
    "node_modules"
    "scripts"
    "\.env"
    "\.e"
    "cache")
ExclusionStr="${ExclusionList[@]}"

updateArrayScripts() {
    local arr=$@
    echo ============== updateInstallScripts ===================
    for element in $arr
    do
        if [ "$newFile" = "$element" ]; then
             echo "SKIPPING COPY FILE $newFile FOUND"
        else
             echo EXECUTING: cp -f $newFile $element
             cp -f $newFile $element
        fi
    done
}


updateInstallScripts() {
    newFile=$1
    echo "updateInstallScripts(): $newFile"

    doubleLine 80
    searchFile=$INSTALL_SCRIPT
    singleLine 80

    getFilePathList $searchFile $ExclusionStr
    #myFileList=$(getFilePathList $searchFile)

    sortedUniqueText=$(sortUniqueTextArray $scriptList)
    echo sortedUniqueText=$sortedUniqueText
    dumpArray $sortedUniqueText
    echo
    updateArrayScripts $sortedUniqueText
}

updateInstallScripts $PWD/$INSTALL_SCRIPT

