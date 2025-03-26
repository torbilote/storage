# Simple Storage Service (S3)

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

# CloudFront

Content Delivery Network (CDN) - group of geographically distributed servers that speed up the delivery of web content by bringing it closer to where users are.
CloudFront is AWS CDDN service.
It caches content and assets to increase global performance.
Main component are edge locations (cache endpoints), the origin (original source of truth) and the distribution (the network).

When content is cached - it is done for certain time limit called Time To Live (TTL) - always in seconds.
Can serve up entire websites.
Requests always cached in the nearest edge location for the user.
Two types of distributions:
Web Distribution : web sites, normal cached items,
RTMP: streaming content

Edge locations are read and write.
Can invalidate the distribution of certain objects so the content is loaded directly from the origin.
Origin Access Identity (OAI) is used for sharing private content via CloudFront.

Signed URLs and Signed Cookies - allow you to control who can access your content.
Use signed URLs when:
- you want to use RTMP disribution.
- you want to restrict access to individual files,
- your users are using a client that doesnt support cookies.

Use signed cookies when:
- You want to provide access to multiple restricted files.
- You dont want to change your current URLs.

# Snowball

Giant physical disk used to migrating high quantities of data into AWS. It is petabyte scale data transport solution.
Secure and quick data transfer.

Snowball Edge - type of Snowball that comes with both compute and storage capabilites via Lambda and EC2 instance types.
Allows to run code within your snowball while your data is routed to Amazon data center.

Snowmobile - exabyte scale data transfer solution. Is contained within shipping container. Makes sense when you want to move your entire data center with years of data into the cloud.

# Storage Gateway
Service that connects on-premise environments with cloud-based stroage in order to seamlessly and securely integrate on-prem application with cloud storage backend.
Storage gateway can be either a physical device or a VM image downloaded onto on-prem data center. Acts like a bridge to send/receive data from AWS.
Three types of storage gateways:
- file gateway - used to store files in s3 over a network filesystem mount.
- volume gateway - used to store copies of hard disk drives in s3. 
- tape gateway - virtual tape library.

Relevant file information passing through gateway are stored as objects metadata. Once files are stored in S3, all S3 features can be applied.

Applications interfacing with AWS over Volume Gateway - data written to volumes can be asyncchronuosly backed up into AS Elastic Block Store (EBS) as point-in-time snapshots. Snapshots act likea backup that capture only changed state, lateron all snapshots are compressed to reduce storage costs.
Volume Gateway's Stored Volumes:
let you store data locally on-prem and back up the data to AWS as a secondary data source.
Volume Gateway's Cached Volumes:
AWS is used as primary data source and local hardware is used as a caching layer.

Tape Gateway - cost-effective way of archiving and replicating data into S3 while getting rid of old school data storage.

# Elastic Compute Cloud (EC2)
Elastic Compute Cloud (EC2)

Spins up resizable server instances that can scale up and down quickly. AN instance is a virtual server in the cloud.
You can set up and configure the operating system and applications that run on the instance.
Extremaly quick provisioning and booting new instances.
Its configuration at launch is live copy of Amazon Machine Image (AMI)

Charging for:
CPU, memory, storage, networking. when stopped, charged for storage only.

You can launch different type of instances from single AMI. Type determines the hardware of your instance meaning different compute and memory capabilites.
You can import existing VMs into AWS as long as compatible.
When you launch an EC2 instance, you can pass user data when it starts to run common automated configuration tasks or scripts.
By default the public IP address of EC2 instance is released when the instance is stopped.
Best practise is to refer to instance by its external DNS hostname.
If you require persistent public IP for same instance - use Elastic IP address.
Instance status checks check the health of the running EC2 server
System status checks monitor the health of the underlying hypervisor.

Pricing:
On-Demand instances - pricing based on fixed rate by hour or second. You can start it and stop whenever you need. No long term commitment.
Reserved instances - 1 - 3 year contract term. Provides significant discounts at hourly rate.
Spot instances - Only available when Amazon has excess capacity. You must financially bid for access. Instance can be stopped due to a price change. Usually used in batch processing jobs when your app has flexible start and end times.

Standard Reserved - Inflexible reservations. Discounted significantly. Cannot be moved between regions.
Convertible Reserved - Less discounted. You can modify the instance type at any point. 
Scheduled Reserved - Reserved according to specified timeline.

Security:
You are responsible for instance management including updates, security patches and the configuraion of the AWS-provided firewall (security group).
EC2 uses public-private keys to encrypt/decrypt login information.

Placement Groups:
balance the tradeoff between risk tolerance and network performance in your fleet of EC2 instances.

Clustered placement groups: when you put all of your EC2 insstances in a single availability zone. Recommended for apps that need the lowest latency possible and the highest network thoroughput.
Spread placement groups: when you put each individual EC2 instance on its own distinct hardward so that the failure is isolated. Recommended for apps that have a small number of critical instances.
Partitioned Placement groups; similar to former, but multiple instances can be within a single partition and partitions are isolated. Balanced solution.

# Elastic Block Store (EBS)
Elastic Block Store (EBS) volume is durable block-level storage device. Think of it as cloud-based virtual hard disk.
Can be attached to EC2 instance. Can be used as primary storage such as the system drive or storage for database application.

Volumes perist independently from running life of EC2 instance
EBS volume is automatically replicated within its availability zone.

5 types of EBS:
- general purpose (SSD)
- provisioned IOPS (SSD built for speed)
- Throughput Optimized Hard Disk Drive (magnetic, built for larger data loads)
- Cold Hard Disk Drive (magnetic, built for less frequently accessed workloads)
- Magnetic

Same availability zone as your EC2 instance
Volume can be attached to one EC2 instance at a time.
Ability to create snapshots/backups of the volume and write copy to S3.
You can moidfy volumes on the fly (size, storage type)

SSD-backed volumes recommended for IOPS heavy workloads whereas HDD-backed for throughput heavy workload.
## sidenote

IOPS - Input/Output Per Second - measures the number of read and write operations a device can perform
Throughput - meassures the amount of data that can be transferred

EBS Snapshots:
Point in time copies of volumes. Capture the state of change from when last snapshot was taken.
First one can take a while.

Root Device Storage:
All AMI root volumes are of two types: EBS-backed or Instance Store-backed.
When delete EC2 instance that was instance store-backed - your root volume will be also deleted.
When its ebs-backed - root volume will not be terminated.
Instance Store cant provide data persistane but has very high IOPS rate.

EBS for data, critical logs, application configs.
Instance for in-process data, noncritical logs,
Use S3 for data shared between systems.

Encryption:
uses AS KMS Customer master keys (CMK) when creating encrypted volumes and snapshots.
What is encrrypted:
- data at rest inside volume
- all data moving between volume and the instance
- all snapshots created from the volume
- all volumes created from those snapshots

# Elastic Network Interfaces (ENI)
Elastic Network Interfaces (ENI) is networking component that represents a virtual network card.
Mainly used for low-budget, high-availability network solutions
If you need high throughput you cna use Enhanced Networking ENI but the downside is that is not available on all EC2 instance types.

# Security Groups (SG)
Security Groups are used to control access to EC2 (SSH, HTTP, etc.).
Act as a virtual firewall for your instances to control inbound and outbound traffic.
Can assign up to 5 security groups to the instance.
Act on the instance level, not the subnet level (NACLs control the same but on the subnet level).
SG control the list of ports that are allowed to be used by EC2 instance and NACLs control which network or list of IP addresses can connect to your whole VPC.
Changes to SG occur immediately.
When you create an inbound rule, an outbound one is created immediately (in contrast to NACLs).
SG rules are based on ALLOWs (no concept of DENY). Everything is blocked by default.
Security Group are specific to single VPC, cant share between multiple VPCs, however you can copy and create new one with the same rules for another VPC.
SG are regional. Cant be cross regional.
Multiple SG to one EC2 and multiple EC2 under one SG.
You can specify SG to be single IP address, IP range or separate security group.

# Web Application Firewall (WAF)
Web application firewall is a web app that lets you allow or block HTTP(S) requests that are bound for CloudFront, API Gateway, App Load Balancers, EC2 (operates on Layer 7).
Gives control over how traffic reaches your application by enabling you to create security rules that block common attack pattern (SQL injection, cross-site scripting etc.)
You can set which IP addresses are allowed to make what kind of requests or access what kind of content.
Outermost border of protecting your AWS ecosystem.
Simply it lets you choose one of the following scenarios:
- Allow all requests except the ones specified - useful for public websites
- Block all requests except the ones specified - usefull for restricted website
- Count the requests that match the properties that you specify - allow/block requests based on new properties.

Protection capabilites by limit access based on:
  - IP address a request came from
  - country request came from
  - values found in request headers
  - any string within the request
  - length of the request
  - presence of sql code or a script
  
