repeat(){
    char=$1
    if [ -z "$2" ]
    then #echo "No argument supplied"
        length=20
    else
        length=$2
    fi
    # echo length = $length
    str=""
    i=1
    while [ $i -le $2 ]
    do
        # echo $i: $1
        let "i++" 
        str="$str$1"
    done
    echo $str
}

doubleLine() { 
    echo $(repeat "=" $1) 
}

singleLine() {
    echo $(repeat "-" $1)
}

underLine() {
    echo $(repeat "_" $1)
}

dumpArray() {
    local arr=$@
     echo =============== dumpArray ============================
     for element in $arr
     do
        echo "$element"
     done
}

updateArrayScripts() {
    local arr=$@
    local scrScript=""
    echo ============== updateInstallScripts ===================
    for element in $arr
    do
    	if [ "$scrScript" = "" ]; then
            scrScript=$element
            echo "SETTING FIRST ENTRY: scrScript=$scrScript"
        else
            echo EXECUTING: cp -f $scrScript $element
            cp -f $scrScript $element
        fi
    done
}

sortUniqueTextArray() {
    local unsortedArray=$@
     IFS=" " read -r -a sortedUniqueArray <<< "$(tr ' ' '\n' <<< "${unsortedArray[@]}" | sort -u | tr '\n' ' ')"
     echo "${sortedUniqueArray[@]}"
}


scriptList=""

getFilePathList () {
    local searchFile=$1
    local exclusionList=$2
    scriptList=""
    buildFileSearchList $searchFile $exclusionList
    echo scriptList
}

buildFileSearchList () {
    local searchFile=$1
    local exclusionList=$2
    singleLine 80

    echo EXECUTING: buildFileSearchList $(PWD)
    echo EXECUTING: buildFileSearchList dir = $dir
    dirs=$(echo "$(ls -d */)" | sed "s/["//"]//g")
    echo EXECUTING: For dir in $dirs

    # echo EXECUTING: for dir in ./*/
    for dir in $dirs          # list directory names
    do
        echo EXECUTING:  dir = $dir

        foundDir=$(echo $ExclusionList | grep $dir)
        
        if [ "$foundDir" != "" ]; then
            echo "\*\*\*Excluding Directory: $dir"
        else
            echo EXECUTING: processDir $dir
            script=$(ls ./$searchFile)

            if [ "$script" != "" ]; then
                scriptList+=$PWD/$searchFile" "
                echo FoundFilePath $PWD/$searchFile
            fi
            cd $dir
            buildFileSearchList $searchFile
            cd .. 
        fi
    done
    underLine 80
}

updateInstallScripts() {
    echo "updateInstallScripts(): PDW=$PWD"
    INSTALL_SCRIPT="scripts/installNodeModules.sh"
    ExclusionList=(
        "artifacts"
        "node_modules"
        "scripts"
        "\.env"
        "\.e"
        "cache")
    ExclusionStr="${ExclusionList[@]}"

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

updateInstallScripts
