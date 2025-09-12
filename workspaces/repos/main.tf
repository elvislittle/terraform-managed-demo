# Repositories-only configuration - updated
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  # token = var.github_token # Set via GITHUB_TOKEN environment variable
}

# Define local variables for repository configuration
locals {
  # Repository definitions with their properties
  repositories = {
    test_api = {
      type     = "backend"
      language = "python"
      has_page = false
    }
    test_web = {
      type     = "frontend"
      language = "javascript"
      has_page = false
    }
  }
}

# Call the repositories module to create repository files
module "repositories" {
  source = "../../modules/repositories"

  # Pass repository configuration to the module
  repos = local.repositories
}
