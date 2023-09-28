

# aws-s3-staticwebsite

This Terraform configuration creates an AWS S3 bucket with website hosting enabled, along with necessary configurations and policies. </br>
This repository has been utilized in creating a template for the onboarding flow used in StackGuardian. 


## Variables

| Name          | Description                                           | Type        | Default                                                                                                                                                                                                                                                                                                                             | Required |
|---------------|-------------------------------------------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| bucket_region | The AWS region where the S3 bucket will be created.   | String      | us-east-1                                                                                                                                                                                                                                                                                                                           | Yes      |
| mime_types    | Mime types of the contents to be placed in S3 bucket. | map(string) | {      " banner.png "   =  " image/png " ,      " favicon.ico "  =  " image/vnd.microsoft.icon " ,      " index.html "   =  " text/html " ,      " logo.png "     =  " image/png " ,      " logo.svg "     =  " image/svg+xml " ,      " main.css "     =  " text/css " ,      " main.js "      =  " application/javascript " ,   } | Yes      |



## Outputs

| **Name** 	| **Description** 	|
|:---:	|:---:	|
| id 	| Name of the created S3 bucket. 	|
| website_domain 	| Domain of the website endpoint. 	|
| website_endpoint 	| The URL of the hosted website. 	|

## License

This project is licensed under the [MIT License](LICENSE).


