# Input variables for the root module

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-demo"
}

variable "author" {
  description = "Author name for the info page"
  type        = string
  default     = "Elvis Little - change by DeveloperBB"
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
  default     = null # Set via GITHUB_TOKEN environment variable
}

variable "tags" {
  default = {}
}

variable "tags" {
  default = {}
}
