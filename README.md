Make sure there is no special characters in csv files by opening it in notepad++ (utf codes)

Create a project  and in clod shell export and authenticate
--------------------------------------------------------------

Location= us-central1 (Iowa)	($0.020 per GB-month)   [NOTE: (Melbourne is $0.023 per GB-month) (us multi  region=$0.026 per GB-month)]
Create a service account= projectowner-liveability
Email address: projectowner-liveability@liveability-ment360.iam.gserviceaccount.com
Grant role as owner under project
Grant users access to this service account= Add the above email in this box
Create a json key for the service account



export PROJECT=liveability-demo
gcloud config set project liveability-demo

Create bucket in cloud storage
------------------------------

gsutil mb -l us-west1 gs://liveabilitydemo_bucket

Create a datset for teh batchdata
-----------------------------------
bq --location=us-west1 mk \
   --dataset batchdata 
	
Clone the data and schema from git to cloud shell
---------------------------------------------------
git clone https://github.com/liveabilityment360/project_liveability

Copy the data, schema and project files to cloud storage
-------------------------------------------
gsutil cp project_liveability/data/* gs://liveabilitydemo_bucket/data/batch_data
gsutil cp project_liveability/schema/* gs://liveabilitydemo_bucket/data/schema/
gsutil cp project_liveability/project_files/* gs://liveabilitydemo_bucket/project_files/


Create a directory
------------------
mkdir batchdata
cd batchdata


1.Need to figure out how to create the service account and download the json file and load it in the cloud storage/project directory, 
also the permissions for various tools/tasks

gsutil cp gs://liveabilitydemo_bucket/service_account/liveability-thrift-0d1e2459c502.json .

figure out how to enable automatically

Google Cloud Datastore enabled in native mode (us-west1)
Google Cloud Dataflow API enabled


copy the py from bucket to the current  directory
-----------------------------------------------------------------------
gsutil cp gs://liveabilitydemo_bucket/project_files/datastore_schema_import.py .   
gsutil cp gs://liveabilitydemo_bucket/project_files/requirements.txt .
gsutil cp gs://liveabilitydemo_bucket/project_files/data_ingestion_configurable.py .

Move the schema file to the current folder
-------------------------------------
gsutil cp gs://liveabilitydemo_bucket/data/schema/*.csv .

Create virtual environment
-------------------------
python3 -m pip install --user virtualenv
virtualenv -p python3 venv
source venv/bin/activate

Install the required libraries
------------------------------
pip install -r requirements.txt


create the schema in firestore for all the files
----------------------------------------------------

python3 datastore_schema_import.py --schema-file=hospitals.csv
python3 datastore_schema_import.py --schema-file=childcarecenters.csv
python3 datastore_schema_import.py --schema-file=religiousorganizations.csv
python3 datastore_schema_import.py --schema-file=restaurants.csv
python3 datastore_schema_import.py --schema-file=schools.csv
python3 datastore_schema_import.py --schema-file=shoppingcentres.csv
python3 datastore_schema_import.py --schema-file=sportsclubs.csv


Run the dataflow pipe line for each csv files seperately(you can run it also by mentioning it as comma seperated
-------------------------

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=hospitals.csv \
--bq-dataset=batchdata


python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=childcarecenters.csv \
--bq-dataset=batchdata


python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=religiousorganizations.csv \
--bq-dataset=batchdata

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=restaurants.csv \
--bq-dataset=batchdata

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=schools.csv \
--bq-dataset=batchdata

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=shoppingcentres.csv \
--bq-dataset=batchdata

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=us-west1 \
--staging_location=gs://liveabilitydemo_bucket/data/staging \
--temp_location=gs://liveabilitydemo_bucket/data/temp \
--project=$PROJECT \
--input-bucket=gs://liveabilitydemo_bucket/ \
--input-path=data/batch_data \
--input-files=sportsclubs.csv \
--bq-dataset=batchdata
