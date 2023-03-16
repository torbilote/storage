output "bucket_name" {
  value       = google_storage_bucket.bucket.name
  description = "Bucket name"
}
output "google_secret_manager_secret_name" {
  value       = google_secret_manager_secret.secret.secret_id
  description = "Secret id"
}
output "google_pubsub_topic" {
  value       = google_pubsub_topic.topic.name
  description = "PubSub Topic name"
}
output "google_pubsub_subscription" {
  value       = google_pubsub_subscription.subscription.name
  description = "PubSub Subcription name"
}
