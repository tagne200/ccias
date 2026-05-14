# Rôle IAM pour le pipeline CI/CD — principe du moindre privilège
resource "aws_iam_role" "cicd_role" {
  name = "agricam-cicd-role-${var.environnement}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Projet = "AgriCam", Type = "CICD" }
}

# Politique stricte : uniquement les actions nécessaires au déploiement Terraform
resource "aws_iam_role_policy" "cicd_policy" {
  name = "agricam-cicd-policy"
  role = aws_iam_role.cicd_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3DeployAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.agricam_stockage.arn,
          "${aws_s3_bucket.agricam_stockage.arn}/*"
        ]
      },
      {
        Sid    = "TerraformStateAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::agricam-tfstate-${var.environnement}/*"
      }
    ]
  })
}
