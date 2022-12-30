#!/bin/bash
Region=$AWS_REGION
#Region="us-west-2"
#Region="us-east-2"
Desired_key=${1:-"nokeyname"}

if [[ $Desired_key == "nokeyname" ]]
then 
  echo "No key name passed in, exiting"
  exit 0 
fi

Existing_key=`aws ec2 describe-key-pairs --region $Region --key-name "$Desired_key" 2>/dev/null | grep KeyName | awk -F\" '{print $4}'`
#echo ":"
#echo ">>$Desired_key<<"
#echo "--$Existing_key--"

if [[ "$Desired_Key" != "$Existing_key" ]]
then
  echo "Key-pair ("$Desired_key") already exists in Acct/Region, will use it for EC2s."
else
  echo "Will create key-pair ("$Desired_key") and use for EC2s in this Acct/Region."
  aws ec2 create-key-pair --key-name "$Desired_key" --query "KeyMaterial" --region $Region --output text > "${Desired_key}.pem"
  #aws ec2 create-key-pair --key-name "$Desired_key" --query "KeyMaterial" --region $Region --output text
fi

##############
