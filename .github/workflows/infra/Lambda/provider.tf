terraform {
    required_providers {
        aws ={
            version =">=4.9.0"
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    shared_credentials_file = ~/.aws/credentials"
    region = "us-east-1"
}