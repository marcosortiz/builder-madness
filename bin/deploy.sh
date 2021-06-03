#!/bin/bash


# Load config
mydir="${0%/*}"
source "$mydir"/config.sh

# Execute sam commands to deploy the package
sam build
sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket $S3_BUCKET
sam deploy --template-file packaged.yaml --stack-name $CFN_STACK_NAME_PREFIX --capabilities CAPABILITY_IAM