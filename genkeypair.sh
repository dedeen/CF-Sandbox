

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

echo "operating in region: $Region"
echo "Desired key = $Desired_key"
Available_keys=`aws ec2 describe-key-pairs --region $Region | grep KeyName`
echo "Found keys:  $Available_keys"

#####

#!/bin/bash
Region=eu-central-1
key=myapp-engine-$Region
Available_key=`aws ec2 describe-key-pairs --key-name $key | grep KeyName | awk -F\" '{print $4}'`

if [ "$key" = "$Available_key" ]; then
    echo "Key is available."
else
    echo "Key is not available: Creating new key"
    aws ec2 create-key-pair --key-name $key --region $Region > myapp-engine-$Region.pem
    aws s3 cp myapp-engine-$Region.pem s3://mybucket/myapp-engine-$Region.pem
fi
###############

/usr/local/bin/aws cloudformation deploy  --stack-name myapp-engine --template-file ./lc.yml --parameter-overrides file://./config.json  --region $Region
##### create stack  #########


Below is an example of a CloudFormation launch configuration stack where you can pass the key.

Resources:
  renderEnginelc:
    Type: AWS::AutoScaling::LaunchConfiguration
    Properties:
      ImageId:
        Ref: "AMIID"
      SecurityGroups:
        - Fn::ImportValue:
            !Sub "${SGStackName}-myapp"
      InstanceType:
        Ref: InstanceType
      LaunchConfigurationName : !Join [ "-", [ !Ref Environment, !Ref ApplicationName, lc ] ]
      KeyName: !Join [ "-", [ !Ref KeyName, !Ref AWS::Region ] ]