# Commands to create AWS vpc and more with awscli

#### Create VPC #######
VPCID=`aws ec2 create-vpc --cidr-block 10.10.0.0/16 | jq '.Vpc.VpcId'|sed s/\"//g`

echo "NEW VPC described as below"
aws ec2 describe-vpcs --vpc-id $VPCID

#### Create subnet under NEW VPC
SUBNETID=`aws ec2 create-subnet --vpc-id $VPCID --cidr-block 10.10.1.0/24 --availability-zone ca-central-1a|jq '.Subnet.SubnetId' | sed s/\"//g`

echo "NEW Subnet descibled as below"
aws ec2 describe-subnets --subnet-id $SUBNETID

echo "Making subnet public so it will have public ip on new ec2 instances"
aws ec2 modify-subnet-attribute --subnet-id $SUBNETID --map-public-ip-on-launch

echo "NEW Subnet descibled as below after making it public"
aws ec2 describe-subnets --subnet-id $SUBNETID

#### Create new internet gateway

IGWID=`aws ec2 create-internet-gateway | jq '.InternetGateway.InternetGatewayId' | sed s/\"//g`

echo "NEW Internet Gateway described as below"
aws ec2 describe-internet-gateways --internet-gateway-id $IGWID

echo "Attaching Internet Gateway to NEW VPC"
aws ec2 attach-internet-gateway --vpc-id $VPCID --internet-gateway-id $IGWID 

echo "NEW Internet Gateway described as below after attaching to VPC"
aws ec2 describe-internet-gateways --internet-gateway-id $IGWID

#### Creating new route table under vpc
RTBID=`aws ec2 create-route-table --vpc-id $VPCID | jq '.RouteTable.RouteTableId'| sed s/\"//g`

echo "NEW Route table described as below"
aws ec2 describe-route-tables --route-table-id $RTBID

echo "Creating new route in route table to connect from and to internet via internet gatway "
aws ec2 create-route --route-table-id $RTBID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGWID 

echo "NEW Route table described as below after creating new route to internet"
aws ec2 describe-route-tables --route-table-id $RTBID

echo "Associating route table to subnet so it will have public route"
ASSOCID=`aws ec2 associate-route-table  --subnet-id $SUBNETID --route-table-id $RTBID | jq '.AssociationId' | sed s/\"//g`

echo "NEW Route table described as below after associating with subnet"
aws ec2 describe-route-tables --route-table-id $RTBID

#### clean demo setup
echo "Deleting the Setup"
aws ec2 disassociate-route-table --association-id $ASSOCID 
aws ec2 delete-route-table --route-table-id $RTBID
aws ec2 detach-internet-gateway --internet-gateway-id $IGWID --vpc-id $VPCID
aws ec2 delete-internet-gateway --internet-gateway-id $IGWID
aws ec2 delete-subnet --subnet-id $SUBNETID
aws ec2 delete-vpc --vpc-id $VPCID
