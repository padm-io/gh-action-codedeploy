#!/bin/sh

set -e

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

# Default to ap-south-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="ap-south-1"
fi

if [ -z "$AWS_S3_LOCATION_KEY" ]; then
  echo "AWS_S3_LOCATION_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_S3_BUNDLE_TYPE" ]; then
  echo "AWS_S3_BUNDLE_TYPE is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_CODEDEPLOY_GROUP_NAME" ]; then
  echo "AWS_CODEDEPLOY_GROUP_NAME is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_CODEDEPLOY_APP_NAME" ]; then
  echo "AWS_CODEDEPLOY_APP_NAME is not set. Quitting."
  exit 1
fi

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
aws configure --profile codedeploy-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Create Deployment using our dedicated profile and suppress verbose messages.
sh -c "aws deploy create-deployment --profile codedeploy-action \
        --region ${AWS_REGION} \
        --application-name ${AWS_CODEDEPLOY_APP_NAME} \
        --deployment-group-name ${AWS_CODEDEPLOY_GROUP_NAME} \
        --s3-location bucket=${AWS_S3_BUCKET},bundleType=${AWS_S3_BUNDLE_TYPE},key=${AWS_S3_DEST_DIR}/${AWS_S3_LOCATION_KEY} >> out.json"

if [ -z "$WAIT_FOR_BUILD" ]; then
  exit 0
fi

export DEPLOY_ID=`head -2 out.json | tail -1 | cut -f4 -d\"`

aws deploy wait deployment-successful --profile codedeploy-action --region ${AWS_REGION} --deployment-id $DEPLOY_ID

# Clear out credentials after we're done.
# We need to re-run `aws configure` with bogus input instead of
# deleting ~/.aws in case there are other credentials living there.
# https://forums.aws.amazon.com/thread.jspa?threadID=148833
aws configure --profile codedeploy-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF