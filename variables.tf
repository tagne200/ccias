variable "environnement" {
  description = "Environnement de déploiement (dev, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-1"
}

variable "account_id" {
  description = "ID du compte AWS"
  type        = string
}
