#!/bin/bash
set -e

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

echo "Status code: " $statusCode

if [ "$statusCode" = "200" ]; then
  echo "Smoke tests passed"
else
  echo "Smoke tests failed"
  exit 1
fi

echo "done"
