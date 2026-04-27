environment          = "prod"
aws_region           = "us-east-1"
artifact_bucket_name = "cicd-state-prod-353666332910"
manage_state_bucket  = true
github_org           = "h-katabami"

code_connections = {
  github = {
    name          = "github-shared-prod"
    provider_type = "GitHub"
  }
}

s3_buckets = {
  backend = {
    bucket_name             = "cicd-state-prod-353666332910"
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
    branch_name     = "prod"
    manual_approval = true
  }
}