# GuardDuty — détection de menaces en continu (analyse logs, DNS, réseau)
resource "aws_guardduty_detector" "agricam" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }

  tags = { Projet = "AgriCam", Type = "Securite" }
}
