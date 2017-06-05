#!/bin/bash
set -e

blue='\e[1;34m';
green='\e[0;32m';
red=$'\e[41m';
nocolor=$'\e[0m';


tmp_dir=$(mktemp -d nevermind.XXXXXXX)
echo $JSON_KEY >> $tmp_dir/key.json
gcloud auth activate-service-account --key-file $tmp_dir/key.json

gcloud config set project $GCP_PROJECT
gcloud container clusters get-credentials $GCP_CLUSTER_NAME --zone=$GCP_AZ
gcloud config set container/cluster $GCP_CLUSTER_NAME

podname=`kubectl get pods --no-headers | cut -d' ' -f1`

echo "Port forward to pod: " $podname

# port forward to the app
kubectl port-forward $podname 8080:80 > /dev/null &
sleep 5

echo "Smoke tests.."
statusCode=$(wget --spider -S http://localhost:8080 2>&1 |grep "HTTP/" | awk '{print $2}')

printf "Status code: ${blue}$statusCode${nocolor}\n"

if [ "$statusCode" = "200" ]; then
  printf "Smoke tests ${green}passed${nocolor}\n"
else
  printf "Smoke tests ${red}failed${nocolor}\n"
  exit 1
fi
