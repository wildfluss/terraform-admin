#!/bin/bash

if [ ! -f ".env" ]; then
    echo .env does not exist
    exit 1
fi

export $(egrep -v '^#' .env | xargs)

# echo $TF_VAR_org_id

gcloud projects delete ${TF_ADMIN}

if [ $? -eq 1 ]; then
    echo Could not delete project $TF_ADMIN
    exit 1
fi

gcloud organizations remove-iam-policy-binding ${TF_VAR_org_id} \
       --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
       --role roles/resourcemanager.projectCreator

if [ $? -eq 1 ]; then
    echo Could not remove the org level IAM permissions create project 
    exit 1
fi

gcloud organizations remove-iam-policy-binding ${TF_VAR_org_id} \
       --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
       --role roles/billing.user

if [ $? -eq 1 ]; then
    echo Could not remove the org level IAM permissions assign billing
    exit 1
fi

