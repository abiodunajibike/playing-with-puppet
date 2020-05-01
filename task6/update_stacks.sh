#!/bin/bash

set -xe

profile=cloud_sandbox
region=us-east-1

puppet_master_stack_name=puppet-master-v1

echo "Creating stack: $puppet_master_stack_name"
response=$(aws cloudformation update-stack \
    --stack-name $puppet_master_stack_name \
    --template-body file://task6/master.json \
    --capabilities "CAPABILITY_NAMED_IAM" \
    --profile $profile \
    --region $region)

echo echo "Creating stack: $puppet_master_stack_name response: $response"

echo echo "Waiting for stack creation of $puppet_master_stack_name to finish"
aws cloudformation wait \
    stack-create-complete \
    --stack-name $puppet_master_stack_name \
    --profile $profile \
    --region $region

puppet_agent_stack_name=puppet-agent-v1

echo "Creating stack: $puppet_agent_stack_name"
response=$(aws cloudformation update-stack \
    --stack-name $puppet_agent_stack_name \
    --template-body file://task6/agent.json \
    --capabilities "CAPABILITY_NAMED_IAM" \
    --profile $profile \
    --region $region)

aws cloudformation wait \
    stack-create-complete \
    --stack-name $puppet_agent_stack_name \
    --profile $profile \
    --region $region
echo echo "Waiting for stack creation of $puppet_agent_stack_name to finish"