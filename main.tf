terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Bucket S3 principal AgriCam (existant depuis exercices précédents)
resource "aws_s3_bucket" "agricam_stockage" {
  bucket = "agricam-stockage-${var.environnement}"
  tags   = { Projet = "AgriCam", Environnement = var.environnement }
}

# Bloquer tout accès public au bucket principal
resource "aws_s3_bucket_public_access_block" "agricam_stockage" {
  bucket                  = aws_s3_bucket.agricam_stockage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
