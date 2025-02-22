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

sortUniqueTextArray() {
    local unsortedArray=$@
     IFS=" " read -r -a sortedUniqueArray <<< "$(tr ' ' '\n' <<< "${unsortedArray[@]}" | sort -u | tr '\n' ' ')"
     echo "${sortedUniqueArray[@]}"
}


scriptList=""

getFilePathList () {
    local searchFile=$1
    shift
    local exclusionList=$@
    scriptList=""
    buildFileSearchList $searchFile $exclusionList
    echo scriptList
}

buildFileSearchList () {
    local searchFile=$1
    shift
    local exclusionList=$@
    singleLine 80

    echo EXECUTING: buildFileSearchList $(PWD) $exclusionList
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
            buildFileSearchList $searchFile $exclusionList
            cd .. 
        fi
    done
    underLine 80
}
