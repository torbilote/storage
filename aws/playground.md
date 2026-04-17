
- create ec2 instance:
```bash
aws ec2 run-instances \ 
--image-id 'ami-073130f74f5ffb161' \ 
--instance-type 't3.micro' \ 
--key-name 'my-ec2-key-pair' \ 
--user-data 'IyEvYmluL2Jhc2ggCiAgICBzdWRvIGFwdCB1cGRhdGU7CiAgICBzdWRvIGFwdCBpbnN0YWxsIG5naW54IC15OwoKICAgIHN1ZG8gc3lzdGVtY3RsIHN0YXJ0IG5naW54OwogICAgc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIG5naW54OwoKICAgIHRvdWNoIGluZGV4Lmh0bWw7CiAgICBUT0tFTj1gY3VybCAtWCBQVVQgImh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L2FwaS90b2tlbiIgLUggIlgtYXdzLWVjMi1tZXRhZGF0YS10b2tlbi10dGwtc2Vjb25kczogMjE2MDAiYDsKICAgIGV4cG9ydCBpbnN0PSQoY3VybCAtSCAiWC1hd3MtZWMyLW1ldGFkYXRhLXRva2VuOiAkVE9LRU4iIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9pbnN0YW5jZS1pZC8pOwogICAgZWNobyAiPGh0bWw+SGVsbG8gaW4gJGluc3QgaW5zdGFuY2UgaWQ8L2h0bWw+IiA+IGluZGV4Lmh0bWw7CiAgICBzdWRvIG12IGluZGV4Lmh0bWwgL3Zhci93d3cvaHRtbC9pbmRleC5odG1sOw==' \ 
--block-device-mappings '{"DeviceName":"/dev/sda1","Ebs":{"Encrypted":false,"DeleteOnTermination":true,"Iops":3000,"SnapshotId":"snap-0a4fcb0b9246b8742","VolumeSize":8,"VolumeType":"gp3","Throughput":125}}' \ 
--network-interfaces '{"SubnetId":"subnet-056072ec6e6e06913","AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-0510eed3b2a74bd67"]}' \ 
--credit-specification '{"CpuCredits":"unlimited"}' \ 
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"my-ec2-ubuntu"}]}' \ 
--iam-instance-profile '{"Arn":"arn:aws:iam::335721753558:instance-profile/my-role-ec2-accessing-s3"}' \ 
--instance-market-options '{"MarketType":"spot"}' \ 
--metadata-options '{"HttpEndpoint":"enabled","HttpPutResponseHopLimit":2,"HttpTokens":"required"}' \ 
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":false,"EnableResourceNameDnsAAAARecord":false}' \ 
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
    sudo apt update;
    sudo apt install nginx -y;

    sudo systemctl start nginx;
    sudo systemctl enable nginx;

    touch index.html;
    TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`;
    export inst=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id/);
    echo "<html>Hello in $inst instance id</html>" > index.html;
    sudo mv index.html /var/www/html/index.html;
    

    curl http://<ip>
```

- check the user data logs.
```bash
    cat /var/log/cloud-init-output.log
```

EC2 needs to be allocated in public subnet within VPC with internet gateway attached. You can also add EC2 instances to target group and then create load balancer.


- run Fargate Task (assuming cluster 'greenbox-cluster' and task definition 'greenbox-task-definition' is already created)
```bash
aws ecs run-task \
--task-definition "greenbox-task-definition" \
--cluster "greenbox-cluster" \
--launch-type "FARGATE" \
--count 1 \
--network-configuration \
"awsvpcConfiguration={subnets=["subnet-0683fc73b91264e78"], securityGroups=["sg-0debfa45e66873e61"], assignPublicIp="ENABLED"}" \
--region "eu-north-1"
```

-- create AWS Lambda
```bash
aws lambda create-function \
--function-name py-pc-components-scraper-lambda \
--package-type Image \
--code ImageUri=335721753558.dkr.ecr.eu-north-1.amazonaws.com/torbilote-dev/py-pc-components-scraper:latest \
--role arn:aws:iam::335721753558:role/py-pc-components-scraper-lambda-execution-role \
--timeout 60 \
--memory-size 512 \
--environment "Variables={PROXY_URL_1=<https://username:password@host:port/>,PROXY_URL_2=<https://username:password@host:port/>}"
```

-- delete AWS lambda
```bash
aws lambda delete-function \
--function-name py-pc-components-scraper-lambda
```

-- update AWS Lambda (ie. when you just update the docker image)
```bash
aws lambda update-function-code \
--function-name py-pc-components-scraper-lambda \
--image-uri 335721753558.dkr.ecr.eu-north-1.amazonaws.com/torbilote-dev/py-pc-components-scraper:latest
``` 