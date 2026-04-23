aws_region           = "ap-northeast-1"
connection_name      = "github-shared-prod"
artifact_bucket_name = "cicd-state-prod-353666332910"

repositories = {
  cicd_test = {
    full_repository_id      = "h-katabami/twilio-flow-custom-parts-cicd-test"
    branch_name             = "prod"
    app_repository_name     = "twilio-flow-custom-parts-cicd-test"
    build_artifact_bucket   = "cicd-state-prod-353666332910"
    manual_approval_enabled = true
  }
}