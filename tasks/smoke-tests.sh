#!/bin/bash
set -e

apt-get update && apt-get install curl -y

tmp_dir=$(mktemp -d nevermind.XXXXXXX)
echo $JSON_KEY >> $tmp_dir/key.json
gcloud auth activate-service-account --key-file $tmp_dir/key.json

gcloud config set project $GCP_PROJECT
gcloud container clusters get-credentials $GCP_CLUSTER_NAME --zone=$GCP_AZ
gcloud config set container/cluster $GCP_CLUSTER_NAME

podname=`kubectl get pods --no-headers | cut -d' ' -f1`

kubectl port-forward phpapp 8080:80 > /dev/null &

echo "Smoke tests.."

statusCode=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

echo "Status code: " $statusCode

if [ "$statusCode" = "200" ]; then
  echo "Smoke tests passed"
else
  echo "Smoke tests failed"
  exit 1
fi


echo "done"
