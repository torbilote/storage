from google.cloud import storage


def list_buckets(project_id: str) -> None:
    """Lists all buckets."""
    storage_client = storage.Client(project=project_id)
    buckets = storage_client.list_buckets()
    print(
        "Cloud Storage -- List of buckets: ",
        *[bucket.name for bucket in buckets],
        sep="\n",
    )


def download_blob(
    project_id: str, bucket_name: str, source_file_name: str, destination_file_name: str
) -> None:
    """Downloads a blob from the bucket."""
    storage_client = storage.Client(project=project_id)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(source_file_name)
    blob.download_to_filename(destination_file_name)
    print(
        f"Cloud Storage -- Blob downloaded successfully. Bucket: {bucket_name}, Blob: {source_file_name}, Dest.: {destination_file_name}."
    )


def upload_blob(
    project_id: str, bucket_name: str, source_file_name: str, destination_file_name: str
) -> None:
    """Uploads a file to the bucket."""
    storage_client = storage.Client(project=project_id)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_file_name)
    # generation_match_precondition = 0
    blob.upload_from_filename(source_file_name)
    print(
        f"Cloud Storage -- Blob uploaded successfully. Bucket: {bucket_name}, Blob: {destination_file_name}, Source: {source_file_name}."
    )


def delete_blob(project_id: str, bucket_name: str, file_name: str) -> None:
    """Deletes a blob from the bucket."""
    storage_client = storage.Client(project=project_id)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    blob.delete()
    print(
        f"Cloud Storage -- Blob deleted successfully. Bucket: {bucket_name}, Blob: {file_name}."
    )
