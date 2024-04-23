provider "aws" {
  region = "us-east-1" # 実際のAWSリージョンに合わせて変更してください
}

# App Runnerサービスの定義
resource "aws_apprunner_service" "aws_data_sync_hub_service" {
  service_name = "aws-data-sync_hub-service"
  source_configuration {
    image_repository {
      image_identifier = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"
    }
  }

  instance_configuration {
    instance_role_arn = "arn:aws:iam::123456789012:role/apprunner-instance-role"
    instance_count = 2
    instance_type = "2vCPU_4GB_RAM"
  }

  auto_scaling_configuration {
    max_size = 3
    min_size = 1
  }
}

# S3バケットの定義
resource "aws_s3_bucket" "aws_data_sync_hub" {
  bucket = "aws-data-sync-hub"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"
    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}

# Amazon Kendraインデックスの定義
resource "aws_kendra_index" "aws_data_sync_hub_index" {
  name     = "aws-data-sync-kendra-index"
  role_arn = "arn:aws:iam::123456789012:role/kendra-index-role"

  description = "Example Kendra Index for document searching"
  edition     = "DEVELOPER_EDITION" # またはENTERPRISE_EDITIONを使用

  document_metadata_configuration {
    name = "FileType"
    type = "STRING_VALUE"

    search {
      displayable = true
      searchable  = true
      sortable    = true
    }
  }

  server_side_encryption_configuration {
    kms_key_id = aws_kms_key.example_kms_key.arn
  }

  # 設定するタグを追加
  tags = {
    Environment = "development"
  }

  capacity_units {
    query_capacity_units   = 1
    storage_capacity_units = 1
  }

  # Kendraのインデックスの他の設定をここに追加
}

resource "aws_kms_key" "aws_data_sync_hub_key" {
  description         = "KMS key for encrypting Kendra indexes"
  enable_key_rotation = true
}
