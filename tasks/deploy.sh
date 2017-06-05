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

kubectl run phpapp --image=markstgodard/phpapp --replicas=1 --port=80
