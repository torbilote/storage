from google.cloud import pubsub_v1
from concurrent.futures import TimeoutError
import json


def send_message_to_topic(project_id: str, topic_id: str, message: dict) -> None:
    """Publishes a message to Pub/Sub topic."""
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id, topic_id)
    data = json.dumps(message).encode("utf-8")
    future = publisher.publish(topic_path, data)
    future.result()
    print("Cloud Pub/Sub -- Message published successfully.")


def acknowledge_callback(message: pubsub_v1.subscriber.message.Message) -> None:
    """Ackowledges receiving a message."""
    print(f"Cloud Pub/Sub -- Message received: {message}.")
    message.ack()


def receive_message_from_subscription(project_id: str, subscription_id: str) -> str:
    """Listens for messages on subscription."""
    subscriber = pubsub_v1.SubscriberClient()
    subscription_path = subscriber.subscription_path(project_id, subscription_id)
    streaming_pull_future = subscriber.subscribe(
        subscription_path, callback=acknowledge_callback
    )
    print(f"Cloud Pub/Sub -- Listening for messages on {subscription_path}..\n")
    with subscriber:
        try:
            streaming_pull_future.result(timeout=10.0)
        except TimeoutError:
            streaming_pull_future.cancel()
            streaming_pull_future.result()
