#!/bin/bash

#export AWS_CONFIG_FILE="$HOME/.config/clouds/aws/centerfield/config"
#export AWS_SHARED_CREDENTIALS_FILE="$HOME/.config/clouds/aws/centerfield/credentials"
#export AWS_DEFAULT_REGION="us-east-1"

export AWS_CONFIG_FILE="$HOME/.aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"

# Set up AWS CLI profiles using okta-aws if needed
#okta-aws login --profile centerfield
