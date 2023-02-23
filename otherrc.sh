#! /bin/bash

cmm() {
    git commit -am "$*"
}


mcd() {
    mkdir $1 && cd $1
}

get_policies_per_role() {
    for p in $(aws iam list-attached-role-policies --role-name $1 --query "AttachedPolicies[].PolicyArn" --output text)
    do
        aws iam get-policy-version \
                --policy-arn $p \
                --version-id $(aws iam get-policy --policy-arn $p --query "Policy.DefaultVersionId" --output text) \
                --query "PolicyVersion.Document" \
        | yq -P \
        > $(awk -F / '{print $NF}' <<< $p).yaml
    done
}

jtoy() {
    orig=$1
    yq -P $orig > ${orig%%.json}.yaml
}

ytoj() {
    orig=$1
    yq -o j $orig > ${orig%%.yaml}.json
}

aws_list_vpc_dependencies(){
    vpc=$1
    region=${2-us-east-1}
    aws ec2 describe-internet-gateways --region $region --filters 'Name=attachment.vpc-id,Values='$vpc | grep InternetGatewayId
    aws ec2 describe-subnets --region $region --filters 'Name=vpc-id,Values='$vpc | grep SubnetId
    aws ec2 describe-route-tables --region $region --filters 'Name=vpc-id,Values='$vpc | grep RouteTableId
    aws ec2 describe-network-acls --region $region --filters 'Name=vpc-id,Values='$vpc | grep NetworkAclId
    aws ec2 describe-vpc-peering-connections --region $region --filters 'Name=requester-vpc-info.vpc-id,Values='$vpc | grep VpcPeeringConnectionId
    aws ec2 describe-vpc-endpoints --region $region --filters 'Name=vpc-id,Values='$vpc | grep VpcEndpointId
    aws ec2 describe-nat-gateways --region $region --filter 'Name=vpc-id,Values='$vpc | grep NatGatewayId
    aws ec2 describe-security-groups --region $region --filters 'Name=vpc-id,Values='$vpc | grep GroupId
    aws ec2 describe-instances --region $region --filters 'Name=vpc-id,Values='$vpc | grep InstanceId
    aws ec2 describe-vpn-connections --region $region --filters 'Name=vpc-id,Values='$vpc | grep VpnConnectionId
    aws ec2 describe-vpn-gateways --region $region --filters 'Name=attachment.vpc-id,Values='$vpc | grep VpnGatewayId
    aws ec2 describe-network-interfaces --region $region --filters 'Name=vpc-id,Values='$vpc | grep NetworkInterfaceId
    aws ec2 describe-carrier-gateways --region $region --filters Name=vpc-id,Values=$vpc | grep CarrierGatewayId
    aws ec2 describe-local-gateway-route-table-vpc-associations --region $region --filters Name=vpc-id,Values=$vpc | grep LocalGatewayRouteTableVpcAssociationId    
}

snc(){
    if [[ "$HOST" == "DARWIN-004.local" ]]
    then
        h=saziba@sazibamacpro.local
    else
        h=itagyba.kuhlmann@DARWIN-004.local
    fi
    dn=$(dirname $1)
    rsync -auhvP ${h}:~/$1 ~/$dn
    rsync -auhvP ~/$1 ${h}:~/$dn
}