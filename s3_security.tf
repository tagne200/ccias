# Chiffrement côté serveur AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "agricam_chiffrement" {
  bucket = aws_s3_bucket.agricam_stockage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning — protège contre suppressions accidentelles/malveillantes
resource "aws_s3_bucket_versioning" "agricam_versioning" {
  bucket = aws_s3_bucket.agricam_stockage.id

  versioning_configuration {
    status = "Enabled"
  }
}
