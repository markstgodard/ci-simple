#!/bin/bash
set -e

echo "Running unit tests"

# TODO: complete hack to slow things down
sleep $[ ( $RANDOM % 5 )  + 1 ]s

