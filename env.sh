#!/bin/bash

# source env.sh

export AWS_ACCESS_KEY_ID=minio-key
export AWS_SECRET_ACCESS_KEY=minio-secret
alias aws="aws --endpoint-url http://localhost:9000"
