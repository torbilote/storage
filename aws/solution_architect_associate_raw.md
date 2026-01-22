# Identity Access Management (IAM)
Identity Access Management (IAM) offers a centrialized hub of control within AWS and integrates with all other AWS services.
Ability to share access at various levels of permission.
Ability to use identity federation (delegating authentication to trusted external party).
Multi Factor Authentication (MFA) and password rotation policy supported

Entities:
- Users: any individual end user such as employee, system architect, CTO etc.

- Groups: any collection of similar people with shared permissions such as system admins, HR employes, finance teams etc.
Each user within their specific group will inherit the permissions set for the group.

- Roles: any software service that needs to be granted permissions to do its job eg. Lambda needing write permissions to S3 or EC2 instance needing read permission from RDS. In other words, roles are used for delegation and are assumed.

- Policies: the documented rule sets that are applied to grant or limit access. In order for users, groups or roles to properly set permissions, they use policies.
Policies are written in JSON and you can either use custom policies or default ones.
Policies are separated from other entities above because they are not an IAM Identity. Instead, they are attached to IAM Identities so that the IAM identity can perform necessary function.

Identity-based policies can be applied to users, groups and roles. No princial is defined.
Resource-based policies can be applied to resource like S3 or EC2. It defines permissions for a principal accessing the resource.

IAM is global service, not limited by regions.
The root account with complete admin access is the account used to sign up for AWS.
Any new users created have no permissions. 

You can change permissions as many times as you need.

IAM Policies can easily add tags that help define which resources are accessible by whom.

Priority Levels in IAM:
1) Explicit Deny: Denies access to a particular resource and this ruling cannot be overruled.
2) Explicit Allow: Allow access to a particular resource so long as there is no an associated Explicit Deny.
3) Default Deny (or Implicit Deny): IAM identities start off with no resource access. Access instead must be granted.

IAM Access Advisor:
Access advisor show service permissions granted to a user and when those services were last accessed.
You can use this information to revise your policies.

IAM Credentials Report:
report that lists all of your account users and the status of their various credentials.

Permission boundaries sets the maximum permissions an identity-based policy can grant an IAM entity.

Reading IAM Policies:
Each AWS Service has its own set of actions that describe tasks you can perform with that service
ie.:
Amazon EC2
```json
"Action": "ec2:RunInstances"
```

Amazon S3
```json
"Action": "s3:GetObject"
```


Example of IAM identity-based Policy:
```json
{
  "Version": "2012-10-17", 
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "dynamodb:Describe*",
        "dynamodb:List*",
        "dynamodb:GetItem"
      ],
      "Resource": [
        "arn:aws:s3:::mys3bucket",
        "arn:aws:s3:::mys3bucket/*",
        "arn:aws:dynamodb:us-east-1:11112223333:table/mytable"
      ]
    }
  ]
}
```
Effect - either allow or deny
Action - lists of specific resource operations that the policy affects
Resource - lists the specific resources that the policy applies to

* - means wildcard meaning "all"
:: - leaving empty part in resource name evaluates in ??? #TODO

Example of IAM resource-based Policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
```
Principal - can be IAM user, role or AWS service that will be able to assume the specified role 

Resource-based Policy vs Identity-based Policy:
Resource-based policy is needed for example when creating a new role and it defines what principals can perform an action of Security Token Service (STS) (like AssumeRole or GetSecurityToken) on this role.
Identity-based Policy defines what actions the given role can perform within AWS environment.
For example you create a role named 'MyEC2Role' and define a Resource-based policy to allow EC2 instances to assume the role (authorize as this role).
Later on, you define a identity-based policy to allow newly created role 'MyEC2Role' to perform read actions on specific S3 buckets.

IAM policy simulator helps you to understand what actions the user, group or role is allowed or denied to perform.


IAM Identity Center
Centralized place to manage accesses to AWS console for users providing features like single sign on (SSO) etc. 

Best practises:
- require human users to use federation with an identity provider to access AWS using temporary credentials
- require workloads to use temporary credentials with IAM roles to access AWS
- require MFA
- for use cases that require long-term credentials, rotate access keys regularly
- don't use root user for everyday tasks
- apply least-privilege permissions
- use permissions boundaries to delegate permissions management within an account

# Simple Storage Service (S3)

data storage. data storage architecture - data as an objects.
objects contain your data. they are like files.

highly-scalable, secure, durable.

| object storage | block storage |
| --- | --- |
| perform best for big content and high stream | perform strong with database and transactional data |
| data can be stored across multiple regions | the greater the distance between storage and app the higher latency |
| can scale infinitely to petabytes and beyond | limited scalability |
| customizable metadata allows to data to be easily organized | no metadata |


s3 object has:
key - name of the object
value - the data made up of sequence of bytes
version id - optionally
metadata - additional information attached

Objects immediately available after put.
Durability - protection against data loss/corruption - 99.999999999% or 11 9s
Availability - amount of time the data is available to you - ie. 99.99% 
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

Bucket policies (resource-based policies) secure data at bucket level.
access control lists secure data at object level - not recommended

use S3 bucket policies over IAM policies if:
- you want a simple way to grant cross-account access to your s3 environment, without using IAM roles,
- you prefer to keep access control policies in the s3 environment

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
Supports high speed transfer in edge locations.

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

S3 is global and is outside of the VPC.

S3 Gateway Endpoint:
Enables EC2 instances connect to S3 from VPC using private address (public and private subnets).

S3 Object Lambda:
uses lambda functions to process the output of S3 GET request. In other words, Lambda process and modify data before returning it to the requestor.

S3 MFA Delete:
Adds MFA requirements for bucket owners to:
- change the versioning state of a bucket
- permamently delete an object version

The x-amz-mfa request header must be include in the request and the value is a token generated by a software program (ie. Google Authenticator).

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
RTMP: streaming content - discountinued

Edge locations are read and write.
Can invalidate the distribution of certain objects so the content is loaded directly from the origin.
Origin Access Identity (OAI) is used for sharing private content via CloudFront. - depraced, replaced by OAC - Origin Access Control.


Signed URLs and Signed Cookies - allow you to control who can access your content.
Use signed URLs when:
- you want to use RTMP disribution.
- you want to restrict access to individual files,`
- your users are using a client that doesnt support cookies.

Use signed cookies when:
- You want to provide access to multiple restricted files.
- You dont want to change your current URLs.

Improves performance for both cacheable content (images, videos) by caching it and dynamic content by  maintains a persistent pool of connections.

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
Convertible Reservedf - Less discounted. You can modify the instance type at any point. 
Scheduled Reserved - Reserved according to specified timeline.

Security:
You are responsible for instance management including updates, security patches and the configuraion of the AWS-provided firewall (security group).
EC2 uses public-private keys to encrypt/decrypt login information.

Placement Groups:
balance the tradeoff between risk tolerance and network performance in your fleet of EC2 instances.

Clustered placement groups: when you put all of your EC2 insstances in a single availability zone. Recommended for apps that need the lowest latency possible and the highest network thoroughput.
Spread placement groups: when you put each individual EC2 instance on its own distinct hardware so that the failure is isolated. Recommended for apps that have a small number of critical instances.
Partitioned Placement groups; similar to former, but multiple instances can be within a single partition and partitions are isolated. Balanced solution.

Can be attached to the network via Elastic Network Interface (ENI).
Elastic Block Store (EBS) volumes can be attached to EC2 instances for persistent storage.

User data: code to be run the first time you launch your instance (like bash script).
Metadata: information about your EC2 instance from within your instance that you can get from sending an http request to 169.254.169.254 server (IMDS v1 and v2).
 
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

fast snapshot restore (FSR) -  enables you to create a volume from a snapshot that is fully initialized at creation. Low latency. Instant delivery of performance.
## sidenote

IOPS - Input/Output Per Second - measures the number of read and write operations a device can perform
Throughput - meassures the amount of data that can be transferred

---

EBS Snapshots:
Point in time copies of volumes. Capture the state of change from when last snapshot was taken.
First one can take a while.

Root Device Storage / Instance Store:
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

Can use RAID (Redundant Array of Independent Disks)
RAID 0 - for performance
RAID 1 - for redundancy/ fault tolerance
# Elastic Network Interfaces (ENI)
Elastic Network Interfaces (ENI) is networking component/adapter that represents a virtual network card.
Mainly used for low-budget, high-availability network solutions
If you need high throughput you can use Enhanced Networking ENI but the downside is that is not available on all EC2 instance types.

# Elastic Network Adapter (ENA)
Elastic Network Adapter (ENA) is networking component/adapter that represents a virtual network card.
Enhanced networking performance, higher bandwidth and lower inter-instance latency comparing to ENI.


# Elastic Fabric Adapter (EFA)
Elasit Fabric Adapter (EFA) is networking component/adapter that represents a virtual network card.
For high performance computing, ML use cases.

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
  
# CloudWatch
CloudWatch is a monitoring and observability service. Provides data and actionable insights to monitor your applications.
It collects monitoring and operational data in the form of logs, metrics and events.
Can detect anomalous behaviour in your environment, set alarms, take automated actions and troubleshoot issues.
Its all about infrastructure performance (in contrast to CloudTrail which monitor AWS access for security and auditing reasons)
In terms of EC2, CloudWatch can only monitor host level metrics such as CPU, network, disk, status checks. Cannot provide information about memory utilization, disk space utilization or log collection.

CloudWatch Logs:
Helps centralize the logs from all of your systems, applications and AWS services.
Can create log groups.

CloudWatch Events:
Delivers near real-time stream of system events. Events can be used to trigger lambdas. Redefined as Amazon EventBridge.

CloudWatch Alarms:
Sends norifications or automatically make changes to resources you are monitoring based on rules you define.

CloudWatch Metrics:
Represents a time-ordered set of data points.
Various variables you can monitor over time eg hourly CPU utilization.

CloudWatch Dashboards:
Customizable home page in CloudWatch console.

# CloudTrail
Enables governance, compliance, operational auditing and risk auditing of your AWS account.
You can log and monitor account activity related to actions across AWS infrastructure.
Provides event history of AWS account activity including actions taken through AWS Console, AWS SDKs, CLI and API calls.
Regional service.
By default stores last 90 days of events.
Two types of events:
management events - provide information about things normally done by people like user sign in, policy changed, newly created security configuration
data events - provide informatino about resource operations normally done by software like s3 object-level api activity or lambda execution activity
By default only management events are logged.
Logs are stored in S3 and encrypted using Server-Side Encryption by default.

# Elastic File System (EFS)
## sidenote
NFS - Network File System - protocol that allows users to access files on remote computers as if they were local. Used to share files across networks.

---

Elastic File System is a simple and fully managed elastic NFS file system for use within AWS.
Automatically scales your file system storage capacity up or down as you add or remove files without disrupting your application.
While Elastic Block Store (EBS) mounts one volume to one EC2 instance, Elastic File System (EFS) volume can be attached to multiple EC2 instances.
You pay only for the strage that you use so pay as you go.
Can scale up to petabytes and support thousands of concurrent NFS connections.
Data stored in one region.
It is best for storage that is accessed by a fleet of servers rather than just one server.

# Amazon FSx for Windows
Provids fully managed native Microsoft File System.
Place for windows based applications that require file storage in AWS.
Can use Microsoft Active Directory to authenticate int ofile system.
Provides multiple levels of security and compliance.
Can access from variety of compute resources.
All data is encrypted at rest and in transit.

# Amazon FSx for Lustre
Provides easy and cost effective environment to launch and run the open source Lustre file system for high performance computing applications.
Can process massive data sets up to hundreds of gigabytes per second of throughput, milions of IOPS and sub-milisecond latencies.
Compatible with most popular Linux-based AMIs.

Integrated natively with S3.

# Relational Database Service (RDS)
Managed service to set up and scale relational database in AWS. Provides cost-efficient and resizable capacity while automating/outsourcing time-consuming admisitration tasks such as hardware provisioning, database setup, backups etc.

Six database types:
- sql server
- oracle
- mysql
- postgresql
- mariadb
- aurora

Key features:
- read replication for improved performance
- high availability

# sidenote
OLTP - Online Transaction Processing - serves up data for business logic that ultimately composes the core functioning of your platform or application.
OLAP - Online Analytical Processing - serves to gain insights into the data that you have stored in order to make better strategic decisions as a company.

---

RDS runs on virtual machines, but you dont have access to those machines. AWS is responsible for security and maintanance.
RDS is not serverless though.

RDS Multi Availability Zone:
Disaster recovery - standby copies of resources are maintained in separate geographical area.
Supported for all engines except aurora.
During a failover, the recovered former primary becomes new secondary, and the promoted secondary becomes primary. Once original DB is recovered, there will be a sync process kicked off.

RDS Read Replicas:
Read Replication is exclusively used for performance enhancement.
Every write to master database is also passed to secondary (replica) so it becomes a perfect copy of master.
There is no automatic failover when master fails. Need manual intervantion to make read replica a master on its own.
All 6 engines supported.
Each replica has its own DNS endpoint.
The caveat is taht they are subject to small amounts of replication lag. Might be missing some of the latest transactions.

RDS Backups:
two kinds:
- automated backups: allow to recover database at any point in time within a retention period (up to 35 days). The backup data is stored in S3.
- database snapshots: done manually by admin. They are retained even after original RDS instance is terminated.
When you restore DB via automated backups or database snapshots it will provision an entirely new RDS instance with its own DB endpoint.

RDS Security:
You can authenticate to your DB instance using IAM database authentication. Works with mysql and psotgresql. No need to use password, only authentication token. RDS generate a unique string (token) on request. Its valid for 15 minutes. Network traffic SSL encrypted, access centrally managed by IAM instead of individually per DB instance.
Encryption at rest supported for all 6 engines. Done by AWS KMS service. Once enabled, the data, backups and read replicas are encrypted. AWS handles decryption transparently with a minimal impact on performance. Can be enabled only on DB creation, no afterwards. Cannot disable encryption.

RDS Enhanced Monitoring:
Feature that provides metrics in real time. By default stored in CloudWatch Logs for 30 days.

# Aurora
Aurora is AWS flagship database known to combine performance and availability of traditional enterpise databases with the simplicity and cost-effectiveness of open source databases. 10 times cheaper than the commerial database competitors, 5x better performance than mysql and 3x better than postgresql.

Automatic failover to replica.
Involves cluster of DB instances rhather than signle instance.
Cluster Endpoint takes care of load balancing/routing to instances.
Aurora storage is self-healing. Data is being scanned for errors.
Aurora replicas can be both a standby as part of multi availability zone configuration as well as a target for read traffic (as opposed to RDS when multi AZ standby canno be read endpoint - only read replicas can serve that function).
Automated backups enabled. Dont impact performance. Can also take snapshots.
Aurora scales up to 128TB storage, 32 vCPUs and 244GB memory.
Serverless. AUtomatic scaling.
Recommended with infrequent workloads.

# DynamoDB

key-value and document database that delivers milisecond performance at any scale. Fully managed, multiregion, durable, non-SQL database.
Built-in security, backup, restore, in-memory cache.

Main components:
- a collection - serves as the foundational table
- a document - equivalent to a row in SQL table
- key-value pairs - fields within the document or row

Supports both document and key-value based models.
Data stored in SSD.

Two models:
- Eventually Consistent Reads (default) - all copies of data are usually identical within one second after a write operation.
- Strongly Consistent Reads - identical in less than a second.

A relational database does not scale well for the following reasons:
- it normalizes and stores data in multiple tables that require multiple queries to write to disk
- Worse performance as a trade-off of ACID-compliant transaction system.
- uses expensive joins to reassemble required views of query results.
 
High cardinality is good for IO performance. The more distint your partition key values are, the better.

DynamoDB Accelerator (DAX):
Fully managed in-memory cached that can reduce response times from miliseconds to microseconds even at milions of requests per second.
Scale on demand.
Write performance improved as well (write through cache)
One DAX cluster for multiple DynamoDB tables, multiple DAX clusters for a single table.

DynamoDB Streams:
Ordered flow of information about changes to items in DynamoDB table.
When enabled, it captures information about every modification to data items.
You can integrate Lambda to be triggered as response to events in streams.
Stream Information is stored in separate table. 

DynamoDB Global Tables:
multi-region, multi-master replication solution for fast local performance of globally distributed apps.
It replicates your tables across chosen regions.

# Redshift
Fully managed, petabyte scale data warehouse.
Set of nodes which consists of a leader node and one or more compute nodes.
USed for business intelligence. Pulls in very large datasets to perform complex queries for insights.
Fits the use case of OLAP.
You can start with small single-node cluster and scale up to multi-node large cluster with no interruption to the service.
You can save money by reserve nodes for 1 or 3 year period.
Snapshots are point in time. Enabled by default with 1 day of retention. Maximum retention is 35 days.
Can replicate snapshots to different regions.
Can have up to 128 compute nodes.
Efficiency through columnar compression of similar data and Massive Pararell Processing.
Does not require indexes.  
Encrypted in transit using SSL and at rest using AES-256.

Billed for:
- Compute Node Hours (total hours your compute nodes spent querying data)
- Backups
- Data transfer within VPC
  
Need to associate cluster with a security group.
Free storage for snapshots that is equal the storage capacity of your cluster. You are charged for any additional storage at normal rate. Recommended to configure retention period of snapshots. manual snapshots have to be deleted manually.

Redshift Spectrum:
Used to run queries against exabytes of unstructered data in S3.
use massive parallelism.
S3 and cluster must be in same region.

Redshift Enhanced VPC Routing:
When enabled, redshift forces traffic between your cluster and your data repositories through your Amazon VPC.
If disabled - trafiic goes through internet.
By enabling it you can use VPC features sch VPC security groups, network access control lsits (ACLs), VPC endpoint policies and DNS servers.

# ElastiCache
In-memory cache service in cloud. Boost performance of your existing databases. High throughput and low latency.
Great for web applications. 
Offers fully managed Redis and Memcached.
For data that doesnt change frequently and is often asked for.
Memcached - simple caching.
Redis - more complexed caching.
By caching query results, you pay the price of the DB query only once (unless data changes).
Easy scalable.

# Route53
Highly available and scalable Domain Name System (DNS) service.
Can be used to perform three main functions: domain registration, DNS routing, health checking.
DNS is used to map human-readable domain names into an internet protocol (IP) address.
AWS has its own domain registrar.

When you buy a domain name, every DNS addresss starts with an SOA(Start of Authority) record.
It stores information about the name of the server that kicked off the transfer of ownership, the admin who will use the domain, the metadata.
Name Server (NS) records are used by the Top Level Domain hosts (.org, .com, etc.) to direct traffic to the Content Servers.
The Content DNS servers contain the authoritative DNS records.
Browsers talk to the Top Level Domains whenever they are queried and encounter domain name that they do not recognize.
- Browers will ask for the authoritative DNS records assocsiated with the domain.
- Because Top Level Domain contains NS reords, TLD can query Name Servers for their own SOA. Within SOA, there will be requested information.
- Once this information is collected, it will then be returned all the way back to the original browser asking for it.
- Browser -> TLD -> NS -> SOA -> DNS record. 
- Authoritative name servers sstore DNS record information, usually a DNS hosting provider or domain registrar.

Types of DNS records for Router54:
- A records: Fundamental type of DNS record. The 'A' stands for 'address'. These records are used by computer to directly pair a domain name to IP address. A: URL -> IPv4 and AAAA: URL -> IPv6
- CName records: Canonical name. These records are use dto resolve one domain name to another domain name. Ie. the domain of the mobile version of a website may be a CName from the domain of the browser version of that same webstire rather than a seperate IP address. Cannot be used for primary record. CNAME: URL -> URL
- Alias records: These reocrds are used to map your domains to AWS resources such as load balancers, CDN endpoints and s3 buckets. It points domain name to service. Gives dynamic functionality. Alias: URL -> AWS Resource.
- PTR records: Opposite to A record. Maps IP to domain (used in reverse DNS lookups). PTR: IPv4 -> URL.

Alias records recommended for most use cases.

Time To Live (TTL) is the length that a DNS record is cached on resolving servers. Most providers have TTL that lasts 48 hours. The lower TTL the faster DNS changes propagate acorss the internet.

Routing Policies:
When you create a record you choose a routing policy, which determines how Router 53 responds to DNS queries.
Availble policies are:
- Simple Rounting - when you need single DNS record and either one or more Ip addresses behind this record. Route53 returns a random IP from availble options.
- Weighted Routing - You assign weights to records ie. 80% of traffic should go to one and the rest to another. Useful for testing. Each IP address needs separate record.
- Latency-based - Route53 selects the record from available ones that gives the user the quickest speed. New record for every IP.
- failover - monitor health of primary record and failover to other when needed.
- Geolocation - let you choose where traffic will be send based on geographic location of users.
- Geo-proximity - more complex geolocation routing. 
- Multivalue Answer - same as simple routing but allows you to run health checks and the random IP is taken from only healthy IPs.

# Elastic Load Balancers (ELB)
Elastic Load Balancers automatically distributes incoming application traffic across multiple targets such as EC2 instances, Docker containers,
IP addresses and Lambda Functions.

Target group is the group of targets that load balancer routes the traffic and performs health checks like mentioned EC2 instances, lambdas, etc.

High availability, automatic scaling, robust security.
Can be internet facing or application internal.
To route domain traffic to ELB use Route 53 and create Alias record.
ELB never have its own IPv4 (in opposite for network load balancers).

In AWS there are four types of Load Balancers:
- Application LB - best suited for HTTP(S) traffic. Balance load on 7th layer. Support path-based routing, host-based routing. Support containerized apps. 
- Network LB - best suited for TCP traffic when performance is required. Balance load on 4th layer. Capable of managing milions of requests per second with low latency.
- Gateway LB - operates at Layer 3 – listens for all packets on all ports. Deploy, scale and manage 3rd party virtual network appliances. Centralized inspection and monitoring, firewalls, intrusion detection.
- Classic LBs - legacy ELB, balance either HTTP(S) or TCP, but not both.

The lifecycle of a request to view a website behind an ELB:
1. the browser requests the IP address for the load balancer from DNS.
2. DNS provides the IP.
3. With the IP at hand, your browser makes an HTTP request for an HTML page.
4. AWS perimeter devices checks and verifies your request before passing it onto the LB.
5. The LB finds an active webserver to pass on the HTTP request.
6. The webserver returns the requested HTML file.
7. The browser receives  the HTML file it requested and renders the graphical representation of it on the screen.

Load balancers are regional. They do not balance load across different regions.

## sidenote
Storing Session State
Session data such as authentication details are stored in ie. DynamoDB table or ElastiCache and instance retrieves session data from DB table.
When one EC2 instance fails, then another instance can still authorize the user by retrieving the session data from DB table so the user does not need to reauthenticate.

ELB Advanced Features:
X-Forwarded-For header - forwards requester's IP address along with the actual request to backend servers.
Sticky Sessions - bind given user to the specific instance based on cookie generated bounded to the client for the cookie lifetime. All the interaction with the application will be directed to the same host.
Path Patterns - directs requests based on URL path.

Cross Zone Load balancing - feature that guarantees even distribution across Availability Zones
SSL/TLS & HTTPS decryption burden on the load balancer.
Perfect Forward Secrecy - additional safeguards. Frequent and automatic key changes.

Secure Listener - provides encrpytion in transit 
# Auto Scaling
Auto scaling lets you build scaling plans that automate how groups of different resources respond to changes in demand.
Optimize availability, costs or a balance of both.
Major benefit from the cloud.

Has three components:
- groups : these are logical components ie. webserver group of EC2 instances, database group of RDS instances etc.
- configuration templates: groups use a template to configure and launch new instances to better match the scaling needs. You can specify information like what AMI to use, the instance type, security groups etc.
- scaling options: provides several ways for you to scale the groups. You can base the scaling trigger on the occurence of specified condition or on a schedule.

Auto Scaling generally gain the benefits like:
better fault tolerance, better availability.

Scaling is flexible and can be set up in various ways:
- based on demand,
- ensure the current number of instances at all times,
- scale only with manual intervention,
- scale on a schedule,
- predictive scaling using AI/ML

Termination policy:
automatically terminate a stopped instance (unless configured to do otherwise)
spare instances you tell are running critical systems or apps
ensure that network architecture spans evenly

Cooldown Period:
configurable setting that helps to ensure it doesnt launch or terminate additional instances before the previous scaling acitivty takes effect.

# Virtual Private Cloud (VPC)
Virtual Private Cloud lets you provision a logically isolated section of AWS cloud where you can launch services and systems within a virtual network that you define.
It gives the option to select which resources are public facing and which are not.
Generally VPC provides much more granular control over security.

You can think of VPC as your own virtual data center. You have complete control over your own network including the IP range, the creation of sub-networks (subnets),
the configuration of route tables and the network gateways used.

You can then launch EC2 instances into a subnet of your choosing, assign security groups to them, and create Network Access Control Lists (NACLs) for the subnets as additional protection.

This customization gives you much more control to specify and personalize your infrastructure setup. Ie. you can have one public-facing subnet for your webserver to receive HTTP traffic and then a different private-facing subnet for your database servre where intenre access is forbidden.

VPCs come with defense in depth by design. From the subnetwork (NACLs) down to individual server (security group) and further down to the application itelf (secure coding practises) you can set up multiple levels of protection.

By default all subnets are internet accessible. VPC permits subnets to have a route out to the internet.
You can have as many custom VPCs as you want and all are private by default. When creating new VPC, subnets and gateways are not created by default so you must create them separately. However the following are created by default: a route table, a NACL, a security group.

Whether the traffic originates from outside of the VPC or from within it, it must first go through the route table by way of the router in order to know where the desired destination is. Once that is known, the traffic then passes through subnet level security as described by the NACL. If the NACL evaluates the traffic as valid, the traffic then passes through the instance level security as described by the security group. If the traffic hasnt been stopped at this point, only then it will reach its intended instance.

When you create a VPC you must assign it an IPv4 CIDR block. It is a range of private IPv4 addresses that will be inherited by your instances when you create them. The IP range of VPC by default is always /16 (65k of individual IP addresses).

When creating IP ranges for your subnets, the ranges must be within the VPC IP range.
/32 denotes a single IP address and /0 refers to the entire network.
The higher you go in CIDR the more narrow the IP range will be.
It  regards to both public and private addresses.

Private IP addresses are not reachable over the Internet and instead are used for communication between the instances in your VPC.
When you launch an instance into a VPC, a private IP address from IPv4 address range of the subnet is assigned to the default network interface of the instance. This means that all instances within a VPC have a private IP but only those selected to communicate with the external world have a public IP.

You can optionally associate an IPv6 CIDR block to VPC and subnets as well.

VPCs are region specific.

## VPC subnets
If a network has a large nmber of hosts without logically grouped subdivisions, managing the many hosts can be a tedious job. Therefore you use subnets to divide a network so the management becomes easier.

Subnets improve traffic flow (speed and performance) of the entire network. An Internet gateway (IGW) receiving a packet and checking which of 5 subnets the packet should be delivered to is much faster checking 100 instances individually.
Also, if the destination of a packet is within the subnet from where it originates, the traffic stays inside the subnet and doesnt clutter the rest of the VPC.
Subnets function as a logical groups.

## Network Access Control Lists (NACL)
Network Access Control Lists are like security groups but for subnets rather than instances. 

Comparison between NACL and SG

| NACL | Security Group |
| --- | --- |
| Operates at the subnet level |	Operates at the instance level |
| Supports allow rules and deny rules	| Supports allow rules only |
| Is stateless: Return traffic must be explicitly allowed by rules |Is stateful: Return traffic is automatically allowed, regardless of any rules |
| We process rules in order, starting with the lowest numbered rule, when deciding whether to allow traffic	| We evaluate all rules before deciding whether to allow traffic |
| Automatically applies to all instances in the subnets that it's associated with (therefore, it provides an additional layer of defense if the security group rules are too permissive) | Applies to an instance only if someone specifies the security group when launching the instance, or associates the security group with the instance later on |

For NACL its important that you must also ensure that outbound rules exist alongside the inbound rules.
The default NACL has a default rule to allow all inbounds and outbounds. This means it exists but doesnt do anything as all traffic passes through.
On the other hand when you create a new NACL (instead of using the default one), the default rules will deny all inbounds and outbounds.

NACLs are evaluated before security groups and block malicious IPs with NACLs, not security groups.

NACL rules are evaluated by rule number, from lowest to highest so order matters.

If using NAT gateway along with NACL, you must ensure that NAT port range is within the rules of your NACL.

## NAT Instances vs NAT Gateways:
NAT - Network Address Translation

Attaching an Internet Gateway to a VPC allows instances with public IPs to directly access the internet.
NAT does the same thing however it is for instances that do not have a public IP. It serves as an intermediate step which allow private instances to first mask their own private IP as the NAT's public IP before accessing the internet.

You would want your private instances to access the internet so that they can have normal software update.

NAT prevents any initiating of a connection from the internet.

NAT instances are individual EC2 instances that perform the function mentioned above.
Because they are individaul instances, they can become a choke point in your VPC because they are not fault-tolerant  and serve as a single point of failure.
In NAT instances you have must disable source/destination checks.
(thus deprecated but usable)

For scalable solution its far better to use NAT Gateway.
It is a managed service that is compose of multiple instances linked with each other aithin an AZ to achieve high availability by defualt.
You just need a route rule to route traffic from a private subnet to your NAT gateway.

NAT gateway is created in the public subnet.

## Bastion hosts
Bastion Hosts are instances to remotely access the instances behind the private subnet for system administration without exposing the host via internet gateway via SSH protocol.
The best way to implement a Bastion Host is to create a small EC2 instance that only has a security group rule for a single IP address.
Bastion Host live within public-facing subnet similarly to NAT gateways.

## Route Tables
Route tables are used to make sure that subnets can communicate with each other and with the external network/internet and that the traffic knows where to go.
Every subnet that you create is automatically associated with the main route table for the VPC.
You can have multiple route tables.
If you dont knwo your new subnet to be associated with the default route table, you must specifya different route table. If the default route table is public then all new subsets associated with it will also be public. Best practise is to ensure that default route table is private meaning there is no route out to the internet for the default route table.
If you create a custom route table that is public, all new subnets will not have route out to the internet.
Route tables can be confirued to access endpoints (public services accessed privately) and not just the internet.

Ie. Main Route Table
| Destination | Target |
| --| --|
| 10.0.0.0/16 | Local |
| 0.0.0.0/0 | Internet Gateway |


## Internet Gateway (IGW)
It connects your VPC with the internet.
When a Public IP address is assigned to an EC2 instance, it is effectively registered by the Internet Gateway as a valid public endpoint.
However each instance is only aware of its private IP and not its public IP. Only the IGW knows the public IPs that belong to instances.
One IGW per VPC.

## Virtual Private Network (VPN)
VPN connects your on-prem with your VPC over the internet.
Virtual Private Network can serve as a bridge between your corporate data center and the AWS cloud.
With VPN, your VPC becomes an extensino of your on-prem environment.
You can allow your instances in VPC to communice with your on-premise servers by:
- attaching virtual private gateway to the VPC
- creating custom route table for the connection
- updateing security froup to allow traffic from teh connection
- creating the managed VPN connection itself.

Also customer gateway resource in AWS must be defined. its a physical device or software app on the on-prem side.

## DirectConnect:
DirectConnect connects your on-prem with your VPC through a non-public tunnel.
It established a dedicated network connection between your premises and AWS.
Reduces network costs and increases bandwidth comparing to internet-based connections.
Use case is high throughput workloads or if you need stable and reliable connection.

## VPC Endpoints
VPC Endpoints connect your VPC with AWS services through a non-public tunnel.
It ensures that you can connect your VPC to supported AWS resources without requiring internet gateway, NAT devide or any other connection service.
Traffic between VPC and AWS services stay within the AWS ecosystem.

Two types:
| - | Interface Endpoint | Gateway Endpoint |
| --- | --- | --- |
| What | Elastic Network Interface with a Private IP | A gateway that is a target for specific route |
| How | Uses DNS entries to redirect traffic | Uses prefix lists in the route table to redirect traffic |
| Which services | API Gateway, CloudFormation, CloudWatch etc. | Amazon S3, DynamoDB |
| Security | Security Groups | VPC Endpoint Policies |



## PrivateLink
PrivateLink connects your AWS services with other AWS services through a non-public tunnel.
It simplifies the security of data shared with cloud-based applications by eliminating the exposure of data to the public internet.
Provides private connectivity between different AWS services within Amazon network.

## VPC Peering
VPC Peering connects your VPC to another VPC through a non-public tunnel.
Allows to connect one VPC with another via direct network route using private IPs belonging to both.
Instances in different VPCs behave as if they were on the same network.
Usual practise is that there is only one central VPC that peers with others. Only the central can talk to the other VPCs.
CIDR blocks cannot overlap.
Uses private IP addresses.
Connections are not transitive - full mesh required.

## VPC Flow Logs
VPC Flow Logs is a feature that captures the IP information for all traffic flowing into and out of your VPC.
Data is sent to an S3 bucket or CloudWatch where you can view, retreive and analyze this data.
It captures packets metadata and not packets contents so things like source IP, destination IP, packet size. It catches traffic flowing into and out of VPC, subnets and network interfaces of EC2 instances.
Can be configurable according to the needs.

## AWS Global Accelerator (GA)
Global Accelerator accelerates connectivity over TCP or UDP to improve performance and availability for users.
It directs traffic to optimal endpoints worldwide.
By default it provides you two static IP addresses that you can make use of.
Its fast and reliable pipeline between user and application.

Compared to CloudFront - both use global network, Cloudfront simply caches static content to the closest AWS Point of Presence (POP) location, while GA use the same POP accept initial requests but then routes them directly to the services.
Compared to Route53 - Route53 simply help choosing which region for the user to use. Route54 has nothing to do with actually providing a fast network path.

Good fit for non-HTTP use csaes such as gaming (UDP), IoT (MQTT).
For HTTP good fit when use case require static IP addresses.

# Simple Queuing Service (SQS)
Simple Queuing Service is web-based service that give you access to message queue that can be used to store messages while waiting for another service to process them.
The main point is to decouple work across systems. This way, downstream services in a system can perform work when they are ready to rather  than when upstream services feed them data. 
Pull-based service meaning the downstream service queries SQS for information.
Two types of SQS queues:
-standard queues: messages might be received out of order based on message size or however queues decide to optimize. Guaranteee that a message is delivered at least once making it possible on occasion that a message might be delivered more than once due to the asynchronous and highly distributed architecture. Nearly unlimited number of transactions per second.
- FIFO queues: guarantees that the order of messages that went int the queue is the same as the order of messages that leave it. Also guaranteed exactly-once processing but is limited to 300 transactions per second.

Messages in the queue can be kept there from one minute to 14 days.

Visibility timeout is a mechanism in which messages marked for delivery are given the time frame to be fully received by a reader. This is done by temporarily making them invisible to other readers. If the message is not fully processed within the time limit, the message becomes visible again. This is another way in which messages can be duplicated. If you want to reduce the chance of duplication, increase the visibility timeout. Max is 12 hours.

Messages in SQS continue to exist after the message is processed, until you delete it. You have to ensure that you delete the message after processing to prevent the message being processed again.

Unlimited number of messages in the queue.

SQS Polling:
Polling means you query SQS for messages.
Long-polling: - technique will only return from the queue once a message is there, regardless if the queue is currently full or empty. The reader needs to wait either for a message to finally arrive or for the timeout. It does not return a response until a message arrive in the queue, reducing your overall cost over time.
Short-polling: Technique will return immediately with either a message that's already stored in the queue or empty.
By default, it uses short-polling as ReceiveMessageWaitTimeSeconds queue attribute is set to 0. If it is set to integer value greater than 0, then its long-polling.

Every time you poll the queue, you incur a charge.

Dead Letter Queue - is a configuration when you add extra standard or FIFO queue that has been specified as dead-letter queue and where all messages that were not processed successfully are placed in. Enables the handling of message failure.

Delay Queue - set a delay on the message visibility. Message becomes visible once the delay seconds passed. 


# Simple Workflow Service (SWF)
Simple Workflow Service is a web service that coordinate tasks between application and people. It is a service that combines digital and human-oriented workflows.
Provides a task-oriented API.
The SWF pipline is composed of three different worker apps:
- SWF actors - workers to trigger the beginning of a workflow
- SWF deciders - workers that control the flow of the workflow once it has been started
- SWF activity workers - workers that carry out the task to completion

AWS recommends to use Step Functions instead of SWF


# Simple Notification Service (SNS)
Simple Notification Service is a pushed-based messaging service that provides a highly scalable, flexible and cost-effective method to publish custom messages to subscribers who wish to be informed about a certain topic.
Mainly used to send alarms or alerts.
Provides topics for high-throughput.
Publisher can fan out messages to a large number of subscriber endpoints for pararell processing including SQS, Lambdas and HTTP webhooks.
Can be also used to fan out notifications to end users using mobile push, SMS and email.
It allows you to group subscribers using topics. A topic is an access point for allowing recipients to dynamically subcsribe for the identical copies of the same notification.
One topic can support deliveries to multiple endpoint types.
Messages are stored redundantly across multiple AZs.

# Kinesis
Kinesis collects, process and analyze real-time streaming data.
You can ingest real-time data such as video, audio, app logs, website clickstreams, and IoT telemetry data.
It enables you to process and analyze data as it arrives insteed of having to wait until all data is collected before processing can begin.
Fully managed service that automatically scales to match throughput.

Kinesis Streams:
Works where the data producers stream data into Kinesis Streams which can retain the data up to 7 days.
Once data is inside Kinesis Streams, the data is contained within shards.
It can continuously capture and store terabytes of data per hours from thousands of sources.

Kinesis Firehose:
Easiest way to load streaming data into data stores and analytics tools.
When data is streamed into it, there is no persistent storage to hold onto it.
Can capture, transform and load streaming data into S3, Redshift, Elasticsearch enabling near real-time analytics.

Kinesis Analytics:
Works both with Streams and Firehose and can analyze data on the fly.
Data is sent elsewhere once it is finished procesing.

Partition keys are used with Kinesis so you can organize data by shard.

# Lambda
AWS Lambda lets  you run code without provisioning or managing servers. 
You pay only for the compute time you consume.
Zero administration.
You upload your code and Lambda takes care of everything required to run and scale your code with high availability.
You can set up your code to be automatically triggered from other AWS services or be called directly from any app.
Ultimate abstraction layer. Serverless.
Supports Go, Python, C#, Powershell, Node.js, Java
Each lambda function maps to one request.
Its priced on the number of requests and the first one milion are free. Afterwards each milion costs.
Also priced on the runtime of your code, rounded up to the neareast 100mb, and the amount of memory your code allocates.
Lambda functions can trigger other lambda functions.
Can be used as event-driven service.

When lambda functions use environment variables, they are encrypted using KMS. When lambda is invoked, those values are decrypted.

AWS X-Ray allows you to debuf your lambda function in case of unexpected behaviour.

Lambda@Edge - allows your lambda functions to customize the content that CloudFront delivers. It adds compute capacity to your cloudfront edge locations and alows you to execut the functions closer to your app's viewers.
Functions run in response to cloudfront events without provisioning or managing servers.
You can use lambda functions to change cloudfront requests and responses at the following points:
- after CF receives a request from a viewer,
- before CF forwards the request to the origin,
- After CF recevies the response from origin,
- Before CF forwards the response to viewer

# API Gateway
Fully managed service to build, publish, manage and secure entire APIs.
Handles all tasks involved in accpeting and processing thousands of concurrent API calls, including traffic management, authorization and access control and monitoring.
No minimum fees or startup costs. You pay only for the API calls and the amount of data transferred out.
Functionality:
- exposes HTTP(S) endpoins for RESTful functionality
- uses serverless functionality to connect to lambda & DynamoDB
- Can send each API endpoint to a different target
- Runs cheaply and efficiently
- Scales readily and eforrtlessly
- Can be version controlled
- Can be conntected to CloudWatch for monitoring and observability
- can throttle requests to prevent attacks

## sidenote
Throttling process is a process responsible for regulating the rate at which application processing is conducted, either statically or dynamically.

API owners can set a rate limit of 1k requests per second for specific API method.
API Gateway tracks the number of requests, any requests over the limit will receive 429 HTTP response.

You can add caching to API by provisioning API Gateway cache and specyfing the size. Improves performance and reduce the traffic.

Supports AWS Certificate Manaager and can make use of free TLS/SSL certificates.

Cross Origin Resource Sharing (CORS):
- Same-origin policy is a concept where a web browser permits scripts contained in one page to access data from another page but only if both pages have the same origin. Enforced by browsers, but ignored by tools like curl or postman.
- CORS allows sharing of restricted resources to be requested from another domain outside the original domain. 

# CloudFormation
CloudFormation is an automated tool for provisioning entire cloud-based environments. Similar to terraform - infrastructure as code (IaC).
Its templates are used for advanced setups consist of many connected services.
CloudFormation can create, update and delete infrastructure.
Template written in YAML or JSON.
Full CloudFormation is called a stack.
An example template that would spin up EC2 instance:
```yaml
Resources:
  Instance: ## logical resource
    Type: 'AWS::EC2::Instance' ## This is what will be created
    Properties: ## Configure the resources in a particular way
      ImageId: !Ref LatestAmiId
      Instance Type: !Ref Instance Type
      KeyName: !Ref Keyname
```

# ElasticBeanstalk
ElasticBeanstalk is another way to script out your provisioning process. It is much simplified than CloudFormation. For less experienced developers.
Just upload your application and it will take care of the underlying infrastructure.


# AWS Organizations
AWS Organizations is an account management service that enables you to consolidate multiple AWS accounts into an organization that you create and centrally manage.
Best practise is to use root account to manage billing only with seperate accounts used to deploy resources.
The point is to properly manage policies around users and services to help centraly govern your environment.
Organizational Units (OUs) can group similar accounts together to administer as a single unit to simplify the management.
You can attach a policy-based control to an OU and all accounts within OU will automatically inherit the policy.
With AWS Organizations you can enable or disacle services using Service Control Policies (SCPs) for orgnaizational units or individual accounts.

aws:PrincipalOrgID - This global key provides an alternative to listing all the account IDs for all AWS accounts in an organization. It simplifies specifying the Principal element in a resource-based policy.

# EventBridge
EventBridge is a serverless service that uses events to connect application components together, making it easier for you to build scalable event-drvien applications.
Provides a way to ingest, filter, transform and deliver events.
Two ways to process events:
- Event buses - routers that receive events and delivers them to zero or more targets. Well-suited for routing from many sources to many targets with optional transofmration.
- Pipes - intendede for point-to-point integrations meaning it receives events from single source for processing and delivery to a single target.
Often used together so pipe with an event bus as its target.

# Web Identity Federation
Lets you give your users access to AWS resources after they have successfully authenticated int oa web-based identity provider such as Facebook, Google, Amazon etc. Following a successfull login into these services, the user is provided an auth code from the identity provider which can be used to gain temporary AWS credentials.
# Amazon Cognito
AWS service that provides Web Identity Federation. Cognito's job is broker between your app and legitimate authenticators.
Cognito User Pools - are user directories that are used for sign-up and sign-in functionality. Successfull authentication generates JSON web token. Handles registration, recovery and authentication.
Cognito Identity Pools - are used to allow users temp access to direct AWS services like S3, or DynamoDB. It grants you the IAM role.
For non-IAM users, SAML-based authentication can be used to log in (ie. Microsoft Active Directory).

You can use Cognito to deliver temporary, limited-priviledgge credentials to your application.

# AWS Resource Access Manager (RAM)
Resource Access Manager is a service that enables you to easily and securely share AWS resources with any AWS account or within your AWS Organization.
RAM eliminates the need to create duplicate resources in multiple accounts reducing the operational overhead of managing those resources in every single account you own.
Available at no additional charge.

# Athena
Athena is an interactive query service which allows you to interact and query data from S3 using standard SQL commands.
Serverless.
You pay per query and per TB scanned.
You basically use s3 as SQL supported database.

# Personal Identifiable Information (PII)
Personal data used to establish an individual's identity which can be exploited such phone number, home address, email addres etc.
# AWS Macie
An ML-powered security service that helps you prevent data loss by automatically discovering, classyfing and protecting sensitive data stored in S3.

# AWS Key Management Service (KMS)
Key Management Service is a managed service for creating and controling the encryption keys used to encrypt your data.
Integrated with most of other AWS services.

# AWS Secret Manager
Is a service for managing secrets like database credentials, passwords, third-party API keys or arbitrary text.
You can store and control access to these secrets centrally by secret maanger.
Secret Manager can automatically rotate secret for you on a schedule to reduce the risk of compromise.

# AWS Security Token Service (STS)
Security Token Service is the service that create and provide trusted users with temporary security credentials that grant access to AWS resources.
These credentials are short term lasting from few minutes to several hours. 

# OpsWorks
OpsWorks is a configuration management service that provides managed instances of Chef and Puppet. These are automated platforms to allow using code for configuration automation of your servers.

# Elastic Transcoder
Elastic Transcoder is a media transcoder in the cloud that converts media files from their original format to the specified one.
Pay per minute of transcode job and the resolution of finished work.

# AWS Directory Service
Provides multiple ways to use Amazon Cloud Directory and Microsfot Active Directory with other AWS services.

# IoT Core
Managed service that lets connected devices easily and securely interact with cloud applications and other devices.
Provides communication and data processing across different kind of devices and locations.

# AWS WorkSpaces
WorkSpaces is a managed, secure Desktop-as-a-Service solution. Use to provision either Windows or Linux desktops to workers across the globe.
Quickly scalable.
Eliminates complexity in managing desktop delivery strategy.

# AWS Fargate
Fargate is serverless compute engine for containers.
Allows you to run your containeraized applications without the need to provision and manage the backend infrastructure.
Works with Elasitc Container Service (ECS) and Elastic Kubernetes Service (EKS).
Removes the need to provision and manage servers.

# Elastic Container Service (ECS)
Elastic Container Service (ECS) is a fully managed container orchestration service.
Eliminates the need to install, manage and scale own cluster management infrastructure.
Can use simple API calls to manage apps and access many features integrated with other AWS services.


# Elastic Kubernetes Service (EKS)
Elastic Kubernetes Service (EKS) is a fully managed Kubernetes service.
You can leverage all benefits of open source tooling from the Kubernetes community.
Easy to migrate any standard Kubernetes apps.
Integrated with other AWS services.

## sidenote
Kubernetes is open source software that allows you to deploy and manage containerized applications at scale.

# Data Lifecycle Manager (DLM)
Data Lifecycle Manager (DLM) is used to automate the creation, retention and deletion of snapshots taken to back up your EBS volumes.

# MQ 
MQ is managed message broker service to easy set up and operate message brokers in the cloud.
Used when migrating services and apps into the cloud from your on-prem.

# AWS Config
AWS Config is a service that enables you to audit and evaluate configurations of your AWS resources.
It monitors and records your resource configurations and allow you to automate the evaluation of recorded configurations against desired configurations.

# GuardDuty
is a threat detection service.

# Traffic Mirroring
is a feature that allows you to replicate and send a copy of network traffic from a VPC to another VPC or on-premises location.

# Firewall Manager
is a security management service that helps you to centrally configure and manage firewalls across your accounts.

# Network Firewall
is a managed firewall service that provides filtering for both inbound and outbound network traffic. It allows you to create rules for traffic inspection and filtering, which can help protect your production VPC.

# QuickSight
is a data visualization service that allows you to create interactive dashboards and reports from various data sources, including Amazon S3 and Amazon RDS for PostgreSQL. You can connect all the data sources and create new datasets in QuickSight, and then publish dashboards to visualize the data. You can also share the dashboards with the appropriate users and groups, and control their access levels using IAM roles and permissions.

# Amazon Resource Name (ARN)
Globally unique ID of an individual AWS resource.

# Public IP Addresses
Public IP address is the address that is used to communicate with outside world.
By default the public IP address is a dynamic address meaning each time you restart your instance it gets different public IP assigned.
Public IPs are chargeable.

Elasic IP address is a static public IP address meaning the address is fixed and won't change over time.

Public IP addresses are actually assigned to the virtual network interfaces (ENI, ENA, EFA) and not to the EC2 instance directly.

Elastic IP address can be moved between instances and network adapters.
For example if one EC2 instance fails, you can map your network adapter to new instance keeping the same configuration and same public IP address.

Elastic IP can be associated with either an EC2 instance or with network adapter.

# AWS Control Tower
Allows you to create a landing zone which is a well architected multi account baseline

# IPv4 Address

IP Addresses are written in dotted decimal notation. Ech part of the address is a binary octet. 

| 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 |
|-|-|-|-|-|-|-|-|
| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |

octet - 8 bits - max number 255 ( equivalent of 11111111 (8 1s) in binary notation) x 4 gives 32 bits long address
therefore each part can have a number from 0 to 255

ie. 255.255.255.255 or 192.168.0.1 

Subnet mask has same format and is used to define the network ID and host ID.

Example:
If our IP address is 192.168.123.3
And our subnet mask is 255.255.255.0

Then first 24 bits are identified as network address (8 1s) and the last 8 bits is identified as host address (8 0s).
Therefore:
192.168.123._ or 192.168.123.0/24 - network ID (All resources within the network will have same network ID)
_._._.3 or 0.0.0.3 - host ID. Unique value per individual resource.

# IPv6 Address
128 bits long address. Uses hexadecimal notation rather than decimal.

ie. 2020:0001:9d32:5bc2:1c48:32c1:a93b:b12c

# Transit Gateway
Is a network transit hub that interconnects VPCs and on-premises networks.

# AWS App Runner
Fully managed service for deploying containerized web applications and APIs. Provide the docker image and its ready to go. 

# Step Functions
Serverless service that is used to build distributed applications as a series of steps in a visual workflow.
Scalable orchestration service.
You define a JSON based state machine which is a series of actions and rules that will be triggered respectively.