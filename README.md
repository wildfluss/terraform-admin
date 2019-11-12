# terraform-admin

Create and delete Terraform Admin project.

Use an Admin Project for your Terraform service account to keep the resources needed for managing your projects separate from the actual projects you create.

Create .env file like this:

`TF_ADMIN` must be unique PROJECT_ID e.g. terraform-admin-`openssl rand -hex 3`

```
TF_VAR_org_id=YOUR_ORG_ID
TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
TF_ADMIN=terraform-admin-45e073
TF_CREDS=~/.config/gcloud/terraform-admin.json
```

You can find the values for YOUR_ORG_ID and YOUR_BILLING_ACCOUNT_ID using the following commands:

```
gcloud organizations list --format="value(name)"
gcloud beta billing accounts list --format="value(name)"
```

