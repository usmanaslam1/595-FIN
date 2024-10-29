# Preparations
create-bucket:
	aws --profile cpay s3api create-bucket --bucket curacao-cpay-tf-state --region us-west-2  --create-bucket-configuration LocationConstraint=us-west-2

# Plan lav dev environment
plan-dev-usman:
	terraform plan -var-file=usman-dev.tfvars

apply-dev-usman:
	terraform workspace select dev-usman
	terraform apply -var-file=usman-dev.tfvars

.PHONY: create-bucket apply-dev-usman
