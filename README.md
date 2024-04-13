# GitHub Action to automate deployment with aws CodeDeploy 🔄

This simple action uses the [vanilla AWS CLI](https://docs.aws.amazon.com/cli/index.html) to create a deployment with a AWS CODEDEPLOY

## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

#### The following example includes code deployment from revision is stored in s3 bucket for a website:

```yaml
name: MyApp

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: aws CodeDeploy
        uses: padm-io/gh-action-codedeploy@main
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: "ap-south-1" # optional: defaults to ap-south-1
          WAIT_FOR_BUILD: true
          AWS_S3_LOCATION_KEY: app_v1.0.0.zip # Replace with your build's3-key
          AWS_S3_BUNDLE_TYPE: "zip" # tar | tgz | zip | YAML | JSON
          AWS_CODEDEPLOY_APP_NAME: "myapp"
          AWS_CODEDEPLOY_GROUP_NAME: "myapp_compute"
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository's source code and CI logs.

| Key                         | Value                                                                                                                                                                                                                        | Suggested Type | Required | Default              |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | -------------------- |
| `AWS_ACCESS_KEY_ID`         | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                          | `secret env`   | **Yes**  | N/A                  |
| `AWS_SECRET_ACCESS_KEY`     | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                   | `secret env`   | **Yes**  | N/A                  |
| `AWS_S3_BUCKET`             | The name of the bucket you're syncing to. For example, `jarv.is` or `my-app-releases`.                                                                                                                                       | `secret env`   | **Yes**  | N/A                  |
| `AWS_REGION`                | The region where you created your bucket. Set to `ap-south-1` by default. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) | `env`          | No       | `ap-south-1`         |
| `WAIT_FOR_BUILD`            | Waiting for Build.                                                                                                                                                                                                           | `env`          | No       | N/A                  |
| `AWS_S3_LOCATION_KEY`       | The location key for your stored object on s3. For example, `app_v1.0.0`.                                                                                                                                                    | `env`          | Yes      | N/A                  |
| `AWS_S3_BUNDLE_TYPE`        | Bundle type of your compressed object on s3. Qualified values are `tar \| tgz \| zip \| YAML \| JSON`                                                                                                                        | `env`          | Yes      | N/A                  |
| `AWS_CODEDEPLOY_APP_NAME`   | CodeDeploy App name which your created on your AWS account.                                                                                                                                                                  | `env`          | Yes      | N/A                  |
| `AWS_CODEDEPLOY_GROUP_NAME` | CodeDeploy Group name which your created on your AWS. which is attached to your codedeploy application account.                                                                                                              | `env`          | Yes      | N/A                  |
| `AWS_S3_DEST_DIR`           | The directory inside of the S3 bucket where your object is present. For example, `my_project/assets`. Defaults to the root of the bucket.                                                                                    | `env`          | No       | `/` (root of bucket) |

## License

This project is distributed under the [MIT license](LICENSE.md).
