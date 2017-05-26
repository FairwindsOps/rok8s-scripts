#!/bin/bash -e

if ! hash aws 2>/dev/null; then
  pip install awscli
fi

if [ -z "$AWS_ECR_ACCOUNT_ID" ]; then
  eval $(aws ecr get-login --region $AWS_DEFAULT_REGION)
else
  eval $(aws ecr get-login --region $AWS_DEFAULT_REGION --registry-ids ${AWS_ECR_ACCOUNT_ID})
fi
