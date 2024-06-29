# Terraform Runner

This repo is intended to help execute terraform scripts. It will support targeting both Localstack and AWS. It also allows you to proxy thought Iamlive in order to generate the IAM Policies required to run the commands sent to the AWS API.

## Usage

### Prerequisites

You need the following installed on your machine:

- Docker
- git

### Installation

1. Clone the repo

```bash
git clone ...
```

2. Copy sample environment files

```bash
cp AWS.env.sample AWS.env
cp LOCAL.env.sample LOCAL.env
cp sample.env .env
```

#### .env

The `.env` is used to configure settings specific to your system that will not change whether you target AWS or Localstack. Set the following environment variables:

- `IAMLIVE_AWS_ACCOUNT_ID` - The AWS account ID that you are targeting. This is used to generate the IAM policies required to run the commands sent to the AWS API.
- `TERRAFORM_TEMPLATES_DIR ` - The directory where your terraform templates are stored. This is the directory that will be mounted into the `terminal` container.
- `LOCALSTACK_VOLUME_DIR` - The directory where the Localstack data is stored. This is the directory that will be mounted into the `localstack` container.

#### Local.env

The `LOCAL.env` file will target the Localstack service. It does not need to be modified. It configures the `terminal` service to proxy all requests through the `iamlive` service which redirects all AWS requests to Localstack.

#### AWS.env

Modify the `AWS.env` file to set your AWS credentials. These environment variables will be used when you target AWS.

### Running the Services

Spin up the docker containers and use the `TARGET` environment variable to target either AWS or Localstack.

```bash
# Target AWS With
TARGET=AWS docker-compose up

# Or Target Localstack With
TARGET=LOCAL docker-compose up
```

After the services are running you can connect to the terminal container with the following command:

```bash
docker-compose exec terminal zsh

```

Notice it uses the `zsh` shell. `bash` and `sh` are not available.

### Services

#### Iamlive

When you target Localstack, either by setting `TARGET=LOCAL` or by omitting the `TARGET` environment variable, all requests will be proxied through `iamlive`. The `iamlive` service will redirect all AWS requests to Localstack. Requests to other services, like Azure will not be redirected and will be sent to Azure.

The `iamlive` service will generate the IAM policies required to run the commands sent to the AWS API.

Once you have issued some requests with Terraform or the `aws` cli, you write the generated IAM policies to file. Do this with:

```bash
docker-compose exec iamlive kill -HUP 1
```

The IAM policies will be written to the `./iamlive/volume/iam.policy` file.

#### Localstack

The `localstack` service acts as a mock AWS service. It will respond to all requests as if it were AWS. You can create resources there and query them later. Note that resources are not retained upon restarting the container.

#### Terminal

The `terminal` service is where you will do most of your work. It comes with the `terraform` and `aws` cli's pre-installed. Your Terraform templates will be mounted to the working directory at `/var/app` within the container.

You can then issue Terraform commands like:

```bash
terraform init
terraform plan
terraform apply
```

However, you may need to configure your Terraform AWS account to work with Localhost, as explained below.

### Terraform Provider Configuration

There are a few gotchas when using with terraform and they have to do with the provider configuration. Thie setup does not do authentication and it expects S3 requests to use Path style instead of Virtual Host syle requests.

That means you need to include the following settings in your provider configuration:

```hcl
provider "aws" {
  ...
 skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true
}
```

See the [example provider configuration](./terraform/iamlive-provider.tf) for a complete example.

If you don't include these settings you may see terraform apply and terraform plan hang as they wait for validation or the account id.

Instead you can set the account id to with the IAMLIVE_AWS_ACCOUNT_ID environment variable in the `docker-compose.yaml` file.

## Limitations

### Targeting AWS with Iamlive Proxy

If you would like to target AWS and also proxy the requests through Iamlive, you have to manually edit the `docker-compose.yaml`. By default all requests send to Iamlive are sent to Localstack.

This configured in the `iamlive` service in the `docker-compose.yaml`. You can send requests to AWS, by making the following change to the `docker-compose.yaml`

```diff
version: "3"
services:
  iamlive:
    build: ./iamlive
    volumes:
      - ./iamlive/volume/:/root/.iamlive
    command:
      [
-        "--aws-redirect-host",
-        "localstack:4566",
        "--output-file",
        "/root/.iamlive/iam.policy",
        "--account-id",
        "${IAMLIVE_AWS_ACCOUNT_ID}",
      ]
```

WARNING: Be aware that this will send all requests to AWS. Even if you run the containers with `TARGET=LOCAL`. When you connect to the `infa` container, it will incorrectly say that it is connected to localstack. It will always connect to AWS if you remove these lines.
