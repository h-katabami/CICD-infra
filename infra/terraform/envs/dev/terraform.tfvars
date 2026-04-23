aws_region           = "ap-northeast-1"
connection_name      = "github-shared-dev"
artifact_bucket_name = "cicd-state-dev-237710157750"

repositories = {
  cicd_test = {
    full_repository_id      = "h-katabami/twilio-flow-custom-parts-cicd-test"
    branch_name             = "dev"
    app_repository_name     = "twilio-flow-custom-parts-cicd-test"
    build_artifact_bucket   = "cicd-state-dev-237710157750"
    manual_approval_enabled = true
  }
}