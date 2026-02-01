
- create ec2 instance:
```bash
aws ec2 run-instances \
--image-id 'ami-073130f74f5ffb161' \
--instance-type 't3.micro' \
--key-name 'my-ec2-key-pair' \
--block-device-mappings '{"DeviceName":"/dev/sda1","Ebs":{"Encrypted":false,"DeleteOnTermination":true,"Iops":3000,"SnapshotId":"snap-0a4fcb0b9246b8742","VolumeSize":8,"VolumeType":"gp3","Throughput":125}}' \
--network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-0f5c5ffb86f8c2d7d"]}' \
--credit-specification '{"CpuCredits":"unlimited"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"my-ec22"}]}' \
--metadata-options '{"HttpEndpoint":"enabled","HttpPutResponseHopLimit":2,"HttpTokens":"required"}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count '1' 
```
- connect to ec2 via ssh:
```bash
    ssh -i "my-ec2-key-pair.pem" ubuntu@<public_ip>
    ssh -i "my-ec2-key-pair.pem" ubuntu@<public_dns>
```

- get metadata from within ec2:
```bash
    TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
```

- run simple web server on ec2:
```bash
    #!/bin/bash 
    sudo apt update 
    sudo apt install nginx -y

    sudo systemctl start nginx
    sudo systemctl enable nginx

    touch index.html
    export inst=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id/)
    echo "<html>Hello in $inst instance id</html>" > index.html
    sudo mv index.html /var/www/html/index.html
    

    curl http://<ip>
```

EC2 needs to be allocated in public subnet within VPC with internet gateway attached. You can also add EC2 instances to target group and then create load balancer.

