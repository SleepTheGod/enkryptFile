#!/bin/bash
if [[ $1 == "-e" ]]; then 
    tar -zcf - $2 | openssl aes-256-cbc -salt -out $2.enk
    rm -r $2
fi

if [[ $1 == "-d" ]]; then
    output=`dirname $2`
    openssl aes-256-cbc -d -salt -in $2 | tar -xz -C $output -f - 
    mv $output$output/* $output
    rm -r $output/cygdrive
    rm -r $2
fi
