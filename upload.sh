#!/bin/bash

set -x

AWS_S3_BUCKET=${AWS_S3_BUCKET:-getup-helm-mirror}

aws "$@" s3 sync repo/ s3://${AWS_S3_BUCKET}/