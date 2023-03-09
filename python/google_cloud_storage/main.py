from google.cloud import storage

PROJECT_ID = "norbert-lipinski-learning"
# service account credentials
# os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = r"C:\Users\nlk04\Documents\GitHub\playground\application_default_credentials_service.json"


def list_buckets():
    """Lists all buckets."""
    storage_client = storage.Client(project=PROJECT_ID)
    buckets = storage_client.list_buckets()
    print("LIST OF BUCKETS:", *[bucket.name for bucket in buckets], sep='\n')


def download_blob(bucket_name, source_file_name, destination_file_name):
    """Downloads a blob from the bucket."""
    storage_client = storage.Client(project=PROJECT_ID)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(source_file_name)
    blob.download_to_filename(destination_file_name)
    print(
        f"DOWNLOAD -- Bucket: {bucket_name}, Blob: {source_file_name}, Dest.: {destination_file_name}."
    )


def upload_blob(bucket_name, source_file_name, destination_file_name):
    """Uploads a file to the bucket."""
    storage_client = storage.Client(project=PROJECT_ID)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_file_name)
    # generation_match_precondition = 0
    blob.upload_from_filename(source_file_name)
    print(
        f"UPLOAD -- Bucket: {bucket_name}, Blob: {destination_file_name}, Source: {source_file_name}."
    )


def delete_blob(bucket_name, file_name):
    """Deletes a blob from the bucket."""
    storage_client = storage.Client(project=PROJECT_ID)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    blob.delete()
    print(f"DELETE -- Bucket: {bucket_name}, Blob: {file_name}.")


bucket_name = "norberts-garbage"
bucket_file_name = "website/index.html"
local_file_name = "website/index.html"

list_buckets()
# upload_blob(bucket_name, bucket_file_name, local_file_name)
# download_blob(bucket_name, bucket_file_name, local_file_name)
# delete_blob(bucket_name, bucket_file_name)
