terraform {
  backend "s3" {
    bucket = "cicd-state-dev-237710157750"
    key    = "state/CICD-infra/dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}