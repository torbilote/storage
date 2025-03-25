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
