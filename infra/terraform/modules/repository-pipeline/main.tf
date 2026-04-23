data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pipeline" {
  name               = "${var.name_prefix}-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

resource "aws_iam_role_policy" "pipeline" {
  name = "${var.name_prefix}-pipeline-policy"
  role = aws_iam_role.pipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:GetBucketVersioning"
        ]
        Resource = [
          "arn:aws:s3:::${var.artifact_bucket_name}",
          "arn:aws:s3:::${var.artifact_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = [
          aws_codebuild_project.lambda_build.arn,
          aws_codebuild_project.frontend_build.arn,
          aws_codebuild_project.terraform_plan.arn,
          aws_codebuild_project.terraform_apply.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection"
        ]
        Resource = var.connection_arn
      }
    ]
  })
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.name_prefix}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codebuild_admin" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

locals {
  common_env = [
    {
      name  = "APP_REPO_NAME"
      value = var.app_repository_name
      type  = "PLAINTEXT"
    },
    {
      name  = "DEPLOY_ENV"
      value = var.deploy_env
      type  = "PLAINTEXT"
    },
    {
      name  = "BUILD_ARTIFACT_BUCKET"
      value = var.build_artifact_bucket
      type  = "PLAINTEXT"
    }
  ]
}

resource "aws_codebuild_project" "lambda_build" {
  name         = "${var.name_prefix}-lambda-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = local.common_env

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.lambda_buildspec_content
  }
}

resource "aws_codebuild_project" "frontend_build" {
  name         = "${var.name_prefix}-frontend-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = local.common_env

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.frontend_buildspec_content
  }
}

resource "aws_codebuild_project" "terraform_plan" {
  name         = "${var.name_prefix}-terraform-plan"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = local.common_env

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.terraform_plan_buildspec_content
  }
}

resource "aws_codebuild_project" "terraform_apply" {
  name         = "${var.name_prefix}-terraform-apply"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = local.common_env

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.terraform_apply_buildspec_content
  }
}

resource "aws_codepipeline" "this" {
  name     = "${var.name_prefix}-pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = var.artifact_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        ConnectionArn    = var.connection_arn
        FullRepositoryId = var.full_repository_id
        BranchName       = var.branch_name
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "LambdaBuild"

    action {
      name             = "LambdaBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["LambdaBuild"]

      configuration = {
        ProjectName = aws_codebuild_project.lambda_build.name
      }
    }
  }

  stage {
    name = "FrontendBuild"

    action {
      name             = "FrontendBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["FrontendBuild"]

      configuration = {
        ProjectName = aws_codebuild_project.frontend_build.name
      }
    }
  }

  stage {
    name = "TerraformPlan"

    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceOutput", "LambdaBuild"]
      output_artifacts = ["TerraformPlan"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_plan.name
      }
    }
  }

  dynamic "stage" {
    for_each = var.manual_approval_enabled ? [1] : []

    content {
      name = "Approval"

      action {
        name     = "ManualApproval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          CustomData = "Confirm Terraform plan before apply."
        }
      }
    }
  }

  stage {
    name = "TerraformApply"

    action {
      name            = "TerraformApply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceOutput", "LambdaBuild", "FrontendBuild"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_apply.name
      }
    }
  }
}