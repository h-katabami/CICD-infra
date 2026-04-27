output "pipeline_name" {
  value = aws_codepipeline.this.name
}

output "codebuild_project_names" {
  value = {
    lambda_build    = aws_codebuild_project.lambda_build.name
    frontend_build  = aws_codebuild_project.frontend_build.name
    terraform_plan  = aws_codebuild_project.terraform_plan.name
    terraform_apply = aws_codebuild_project.terraform_apply.name
  }
}