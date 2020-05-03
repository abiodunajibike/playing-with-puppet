#!/bin/bash

set -xe

profile=cloud_sandbox
region=us-east-1

export AWS_DEFAULT_PROFILE=$profile
export AWS_DEFAULT_REGION=$region

bucket_name=learning-puppet-config-12
echo "Creating bucket"
response=$(aws s3api create-bucket --bucket $bucket_name --acl public-read)
echo "Created bucket: $response"

echo "Copying file init.pp"
response=$(aws s3 cp ./task6/environments/production/modules/lamp/manifests/init.pp s3://$bucket_name/init.pp)
echo "Copued file init.pp: $response"

echo "Copying file site.pp"
response=$(aws s3 cp ./task6/environments/production/manifests/site.pp s3://$bucket_name/site.pp)
echo "Copued file site.pp: $response"

puppet_master_stack_name=puppet-master-v2

echo "Creating stack: $puppet_master_stack_name"
response=$(aws cloudformation create-stack \
    --stack-name $puppet_master_stack_name \
    --template-body file://task6/master.json \
    --capabilities "CAPABILITY_NAMED_IAM")

echo "Creating stack: $puppet_master_stack_name response: $response"

echo echo "Waiting for stack creation of $puppet_master_stack_name to finish"
aws cloudformation wait \
    stack-create-complete \
    --stack-name $puppet_master_stack_name

puppet_agent_stack_name=puppet-agent-v2

echo "Creating stack: $puppet_agent_stack_name"
response=$(aws cloudformation create-stack \
    --stack-name $puppet_agent_stack_name \
    --template-body file://task6/agent.json \
    --capabilities "CAPABILITY_NAMED_IAM")

aws cloudformation wait \
    stack-create-complete \
    --stack-name $puppet_agent_stack_name

echo "Waiting for stack creation of $puppet_agent_stack_name to finish"

unset AWS_DEFAULT_PROFILE
unset AWS_DEFAULT_REGION