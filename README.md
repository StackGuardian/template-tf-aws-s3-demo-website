

# aws-s3-staticwebsite

## Terraform AWS S3 Bucket

This Terraform configuration creates an AWS S3 bucket with website hosting enabled, along with necessary configurations and policies.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Variables](#variables)
- [Outputs](#outputs)
- [Release Notes](#release-notes)
- [License](#license)

## Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed on your system.
- AWS credentials configured with necessary permissions.

## Usage

1. Clone this repository to your local machine.
2. Initialize the Terraform configuration:
   ```bash
   terraform init
   ```
3. Adjust variables in `variables.tf` if needed.
4. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```
5. Follow the prompts and review the changes. Confirm by typing `yes`.
6. Once applied, the S3 bucket will be created and configured.

## Variables

- `bucket_region` (string): The AWS region where the S3 bucket will be created. Default: `"eu-central-1"`.
- `mime_types` (map): A mapping of file names to their corresponding MIME types for content uploaded to the bucket.

## Outputs

- `id`: Name of the created S3 bucket.
- `website_domain`: Domain of the website endpoint.
- `website_endpoint`: URL of the hosted website.

## Release Notes

### Version 1.0.0

- Initial release.

## License

This project is licensed under the [MIT License](LICENSE).


