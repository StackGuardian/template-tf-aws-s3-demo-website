

# aws-s3-staticwebsite

This Terraform configuration creates an AWS S3 bucket with website hosting enabled, along with necessary configurations and policies. </br>
This repository has been utilized in creating a template for the onboarding flow used in StackGuardian. 


## Variables

- `bucket_region` (string): The AWS region where the S3 bucket will be created. Default: `"eu-central-1"`.
- `mime_types` (map): A mapping of file names to their corresponding MIME types for content uploaded to the bucket.

## Outputs

- `id`: Name of the created S3 bucket.
- `website_domain`: Domain of the website endpoint.
- `website_endpoint`: URL of the hosted website.


## License

This project is licensed under the [MIT License](LICENSE).


