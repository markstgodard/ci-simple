#!/bin/bash
set -e

echo "Deploying.."

# TODO: complete hack to slow things down
sleep $[ ( $RANDOM % 5 )  + 1 ]s

