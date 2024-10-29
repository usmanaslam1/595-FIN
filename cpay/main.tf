provider "aws" {
  region = "us-west-2"
  # make sure to update aws profile to the project
  profile = "curacao"
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "curacao"
}

terraform {
  backend "s3" {
    # make sure to update aws profile to the project
    profile = "curacao"
    # bucket needs to be created manually
    bucket = "curacao-shopify-tf-state"
    key    = "curacao-shopify"
    region = "us-west-2"
  }
}
