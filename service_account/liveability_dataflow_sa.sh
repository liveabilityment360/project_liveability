# Codes to create a service account and add the necessary roles
export PROJECT="newdataflowdemo"
export SA_NAME="liveability360-service-account"
export SA_DESCRIPTION="Service account for the Liveability project"
export SA_DISPLAY_NAME="Liveability Service Account"
export SERVICE_ACCOUNT_ID="sa-liveability360"

# Generates a new service account.
gcloud iam service-accounts create sa-liveability360 \
    --description="Service account for the Liveability project" \
    --display-name="Liveability Service Account"

# Now assign different roles to the services account.
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:sa-liveability360@$PROJECT.iam.gserviceaccount.com --role=roles/dataflow.admin
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:sa-liveability360@$PROJECT.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:sa-liveability360@$PROJECT.iam.gserviceaccount.com --role=roles/datastore.user
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:sa-liveability360@$PROJECT.iam.gserviceaccount.com --role=roles/storage.admin
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:sa-liveability360@$PROJECT.iam.gserviceaccount.com --role=roles/iam.serviceAccountUser

# Creating a key for the usage in services.
gcloud iam service-accounts keys create key.json --iam-account=sa-liveability360@$PROJECT.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=key.json

#enable dataflow api & firestore api
gcloud services enable dataflow.googleapis.com

gcloud services enable firestore.googleapis.com

#create fire store DB for schema
gcloud app create --region=us-central1
gcloud firestore databases create --region=us-central1 

