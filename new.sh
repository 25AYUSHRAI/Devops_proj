#!/bin/bash

#find files/directories with modify time(mtime) > 7 days and perform action delete
# $1 is path to directory to cleanup
function cleanup {
    find "$1" -mtime +7 -delete
}

#get source_path, des_path, exit staus of transfer(0 if success 1 if fail) then append into the /log.txt file
function log {
    echo "src: $1; des: $2; exit: $3 " >> /log.txt
}

#chk if atleast 2 args passed and not more than 3 passed
# $# returns number of args passed
if [ $# -ge 1 ] && [ $# -le 3 ]; then
    # Check if source exists
    if ! [ -e "$1" ]; then
        echo "file: $1 does not exist"
        exit 1
    fi
    
    # set des file name; basename returns the last file name from the path string,  Ex: file1_22Nov2024
    # set destination file path in path variable
    bfile_name=$( basename "$1" )_$( date +"%d%b%Y" )
    path="$2/$bfile_name"

    # Make destination directory if not exist; use -p to make parent dir if needed and not throw errors
    mkdir -p "$2"

    # Compress and save to destination and exit with success status
    if [ "$3" != "1" ]; then
        # tar [options] [destination] [source]
        tar -czf "$path.tar.gz" "$1"
        log "$1" "$path" $?
        cleanup "$2"
        exit 0
    fi

    # Copy recursively files from source to destination
    cp -r "$1" "$path"
    log "$1" "$path" $?
    cleanup "$2"
    exit 0

#if invalid arguments passed
else
    echo "0 or too many arguments passed"
    exit 1
fi

