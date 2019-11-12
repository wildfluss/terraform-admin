#!/bin/bash

if [ ! -f ".env" ]; then
    echo .env does not exist
    exit 1
fi

export $(egrep -v '^#' .env | xargs)

# echo $TF_VAR_org_id

gcloud projects create ${TF_ADMIN} \
       --organization ${TF_VAR_org_id} \
       --set-as-default

# echo gcloud command exit status $?

if [ $? -eq 1 ]; then
    echo Could not create project $TF_ADMIN
    exit 1
fi

gcloud beta billing projects link ${TF_ADMIN} \
       --billing-account ${TF_VAR_billing_account}

if [ $? -eq 1 ]; then
    echo Could not link to billing account
    exit 1
fi

gcloud iam service-accounts create terraform \
       --display-name "Terraform admin account"

if [ $? -eq 1 ]; then
    echo Could not create the service account
    exit 1
fi

gcloud iam service-accounts keys create ${TF_CREDS} \
       --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

if [ $? -eq 1 ]; then
    echo Could not download the JSON credentials
    exit 1
fi

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
       --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
       --role roles/viewer

if [ $? -eq 1 ]; then
    echo Could not grant service account permission to view Admin Project 
    exit 1
fi

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/storage.admin

if [ $? -eq 1 ]; then
    echo Could not grant service account permission to manage Cloud Storage
    exit 1
fi

gcloud services enable cloudresourcemanager.googleapis.com

# TODO

gcloud services enable cloudbilling.googleapis.com

# TODO

gcloud services enable iam.googleapis.com

# TODO

gcloud services enable compute.googleapis.com

# TODO

gcloud services enable serviceusage.googleapis.com

# TODO

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
       --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
       --role roles/resourcemanager.projectCreator

if [ $? -eq 1 ]; then
    echo Could not grant service account permission to create projects 
    exit 1
fi

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
       --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
       --role roles/billing.user

if [ $? -eq 1 ]; then
    echo Could not grant service account permission to assign billing account
    exit 1
fi

