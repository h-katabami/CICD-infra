terraform {
  backend "s3" {
    bucket = "cicd-state-prod-353666332910"
    key    = "state/CICD-infra/prod/terraform.tfstate"
    region = "ap-northeast-1"
  }
}