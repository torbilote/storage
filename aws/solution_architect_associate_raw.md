# S3

data storage. data storage architecture - data as an objects.
objects contain your data. they are like files.

highly-scalable, secure, durable.

| object storage | block storage |
| --- | --- |
| perform best for big content and high stream | perform strong with database and transactional data |
| data can be stored across multiple regions | the greater the distance between storage and app th higher latency |
| can scale infinitely to petabytes and beyond | limited scalability |
| customizable metadata allows to data to be easily organized | no metadata |


s3 object has:
key - name of the object
value - the data made up of sequence of bytes
version id - optionally
metadata - additional information attached

Objects immediately available after put.
Durability 99.999999999$ or 11 9s
s3 bucket hold objects. buckets can have folders.

s3 is universal namespace so buckets names have to be unique.

individual object up to 5 TB

Features:
pricing variability
encryption
versioning
lifecycle management

S3 charges by:
storage size
number of requests
pricing tier
data transfer
transfer acceleration
cross region replication

Bucket policies secure data at bucket level
access control lists secure data at object level

By default buckets are private

S3 can be configured to create access logs which can be shipped into another bucket for monitoring purposes

S3 can host static websites.

S3 Storage Classes:
- Standard - 11 9s durability. Data stored across multiple facilities.
- IA (Infrequently Accessed) - data needed less often, but data should available fairly quickly. Storage fee is cheeper but you are charged for retrieval.
- IA One Zone - lower availability, lower costs.
- Intelligent Tiering - uses AI to determine the most cost-effective class and then moves your data to appropiate tier.
- Glacier - data archiving. Low cost. Retrieval occasionally needed. Retrieval takes from mintues to hours - depends on chosen method which comes with price.
- Deep Glacier - the lowest cost. Rarely accessed. Retrieval can take 12 hours.

Data can be encrypted both in transit and at rest.

1.In transit: SSL/TLS encryption.
2.At rest: data sitting in s3 is encrypted. Can be done on server side or client side.
 -Server side is when s3 encrypts your data as it is being written to disk and decrypts it when you access it.
 -Client side is when you personally encrypt object on your own before uploading.

On server-side there are following ways of encryption:
1.S3 Managed Keys / Server Side Encryption (SSE) - AWS manages encryption/decryption keys for you automatically. Ease of use. Concede a bit of control.
2.Key Management Service (KMS) - AWS and you both manage encryption and decryption keys together.
3.SSE with customer provided keys - when you give your own keys to AWS to manage. More control. Concede ease of use.

S3 Versioning:
When enabled, S3 stores all versions of an object including all writes and deletes.
Once it is enabled, cannot be disabled, only suspended.
MFA delete capability as additional layer of security.

Lifecycle management:
Automates the moving of objects between the different storage tiers.
Rules can be applied to both current and previous versions of an object.

Cross region replication:
works if versioning is enabled
when enabled only new and subsequent uploads are replicated.
can change tier of replicated content.
Deletes are not replicated.

S3 transfer acceleration:
make use of CloudFront network by sending or reciving data at CDN points instead of uploads/downloads at the origin.

S3 Event Notifications:
Enables to receive and send notifications when certain events happen in your bucket. Need to configure the events you want S3 to publish and where you want S3 to sent notifications.
Supported destinations:
- Simple Notification Service (SNS) 
- Simple Queue Service (SQS)
- Lambda

S3 and ElasticSearch:
If you store log files in S3, ElasticSearch provides full search capabilities for logs.

S3 Read/Write performance:
If request rate for reading/writing to S3 is extremaly high, you can use sequentia date-based naming for your prefixes to improve performance.
Partitions used to store objects will be better distributed.

If GET request rate is high, consider using CloudFront for performance optimization to distribute content via cache for lower latency and higher data transfer rate. 

S3 Server Access Logging:
provides detailed records for the requests that are made to a bucket. Logs saved in same region as bucket.
It Periodically collects access logs records of the bucket, then consolidates them into log files and uploads to monitoring bucket

S3 Multipart Upload:
Allows to upload a single object as a set of parts. Each part is a contiguous portion. Can be uploaded independently and in any order.
Recommended for files over 100MB and only way to upload files over 5 GB.
If transmission of any part fails, you can retransmit only failed part.
After all parts are uploaded, S3 assembles these parts and create the object.
Improved throughput. can be paused and resumed. quick recovery from network issues.

S3 pre-signed urls:
All objects in S3 are private by default.
Object owner can occasionally share private object without having to change the permissions of the bucket to be public.
This is done by creating pre-signed URL.
Using your own credentials, you can grant time-limited permission to download or view private objects.
Anyone who receives the URL can access the object.

S3 select:
Enables to pull out only part of the data from an object which can dramatically improve the performance and reduce cost.

