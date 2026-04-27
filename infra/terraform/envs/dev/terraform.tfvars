environment          = "dev"
aws_region           = "ap-northeast-1"
artifact_bucket_name = "cicd-state-dev-237710157750"
manage_state_bucket  = true
github_org           = "h-katabami"
github_oidc_provider_arn = "arn:aws:iam::237710157750:oidc-provider/token.actions.githubusercontent.com"

code_connections = {
  github = {
    name          = "github-shared-dev"
    provider_type = "GitHub"
  }
}

s3_buckets = {
  backend = {
    bucket_name             = "cicd-state-dev-237710157750"
    versioning_enabled      = true
    encryption_algorithm    = "AES256"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

repositories = {
  twilio-flow-custom-parts-cicd-test = {
    branch_name                = "dev"
    github_actions_branch_name = "dev2"
    manual_approval            = true
    deploy_lambda              = true
    deploy_frontend            = true
  }
}