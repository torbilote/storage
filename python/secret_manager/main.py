from google.cloud import secretmanager


def gcloud_read_secret(project_id: str, secret: str) -> str:
    """Downloads a secret from the secret manager."""
    client = secretmanager.SecretManagerServiceClient()
    response = client.access_secret_version(
        name=f"projects/{project_id}/secrets/{secret}/versions/2"
    )
    payload = response.payload.data.decode("UTF-8")
    print("Secret Manager -- Secret fetched successfully.")
    return payload
