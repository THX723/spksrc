#!/bin/sh

# Package
PACKAGE="bicbucstriim"
DNAME="BicBucStriim"


case $1 in
    start)
        exit 0
        ;;
    stop)
        exit 0
        ;;
    status)
        exit 0
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
