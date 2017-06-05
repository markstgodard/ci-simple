#!/bin/bash
set -e

CI_SCRIPTS=$PWD/ci-scripts

echo "Deploying.."

echo "GCP_PROJECT:" $GCP_PROJECT
echo "GCP_CLUSTER_NAME:" $GCP_CLUSTER_NAME
echo "GCP_AZ:" $GCP_AZ
echo "K8S_NAMESPACE:" $K8S_NAMESPACE

echo "Authenticate with GCP.."

tmp_dir=$(mktemp -d nevermind.XXXXXXX)
echo $JSON_KEY >> $tmp_dir/key.json
gcloud auth activate-service-account --key-file $tmp_dir/key.json

gcloud config set project $GCP_PROJECT
gcloud container clusters get-credentials $GCP_CLUSTER_NAME --zone=$GCP_AZ
gcloud config set container/cluster $GCP_CLUSTER_NAME

kubectl create -f $CI_SCRIPTS/tasks/pod.yml -n $K8S_NAMESPACE


echo -n "waiting for pod"
trycount=0
for i in `seq 1 60`; do
  set +e
  match=`kubectl get pods | grep Running`
  echo $match
  if [ ! -z "$match" ]; then
    echo "pod is running"
    exit 0
  fi
  echo -n "."
  sleep 1
done
echo "pod did not start"
exit 1

