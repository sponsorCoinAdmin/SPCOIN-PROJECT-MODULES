echo PDW=$PWD
INSTALL_SCRIPT="scripts/installNodeModules.sh"
searchFile=$PWD/$INSTALL_SCRIPT
ExclusionList=(
    "artifacts"
    "node_modules"
    "scripts"
    "\.env"
    "\.e"
    "cache")
ExclusionStr="${ExclusionList[@]}"


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

updateInstallScripts() {
    local arr=$@
    local scrScript=""
    echo ============== updateInstallScripts ===================
    for element in $arr
    do
    	if [ "$scrScript" = "" ]; then
            scrScript=$element
            echo "SETTING FIRST ENTRY: scrScript=$scrScript"
        else
            echo EXECTTING: cp -f $scrScript $element
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
    fileList=$1
    singleLine 80

    echo EXECUTING: getFilePathList $(PWD)
    echo EXECUTING: getFilePathList dir = $dir
    dirs=$(echo "$(ls -d */)" | sed "s/["//"]//g")
    echo EXECUTING: For dir in $dirs

    # echo EXECUTING: for dir in ./*/
    for dir in $dirs          # list directory names
    do
        echo EXECUTING:  dir = $dir

        foundDir=$(echo $ExclusionStr | grep $dir)
        
        if [ "$foundDir" != "" ]; then
            echo "\*\*\*Excluding Directory: $dir"
        else
            echo EXECUTING: processDir $dir
            script=$(ls ./$INSTALL_SCRIPT)

            if [ "$script" != "" ]; then
                scriptList+=$PWD/$INSTALL_SCRIPT" "
                echo Replacing installScript $PWD/$INSTALL_SCRIPT
            fi
            cd $dir
            getFilePathList
            cd .. 
            # processDir $dir
        fi
    done
    underLine 80
}

doubleLine 80
echo searchFile=$searchFile
singleLine 80

getFilePathList $searchFIle

sortedUniqueText=$(sortUniqueTextArray $scriptList)
echo sortedUniqueText=$sortedUniqueText
dumpArray $sortedUniqueText
echo
updateInstallScripts $sortedUniqueText
