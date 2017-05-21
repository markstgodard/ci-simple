#!/bin/bash
set -e

echo "Running linting..."

# TODO: complete hack to slow things down
sleep $[ ( $RANDOM % 5 )  + 1 ]s

