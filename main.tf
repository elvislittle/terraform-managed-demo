# Main Terraform configuration that demonstrates module interaction

# Configure the GitHub Provider
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  # token = var.github_token # Set via GITHUB_TOKEN environment variable
}

# Define local variables for repository configuration
locals {
  # Repository definitions with their properties
  repositories = {
    backend = {
      type     = "backend"
      language = "python"
      has_page = true
    }
    frontend = {
      type     = "frontend"
      language = "javascript"
      has_page = true
    }
    infra = {
      type     = "infra"
      language = "terraform"
      has_page = true
    }
    docs = {
      type     = "docs"
      language = "markdown"
      has_page = false
    }
  }
}

# Call the repositories module to create repository files
module "repositories" {
  source = "./modules/repositories"

  # Pass repository configuration to the module
  repos = local.repositories
}

# Call the infopage module and pass repository data from repositories module
module "infopage" {
  source = "./modules/infopage"

  # Use outputs from repositories module as inputs to infopage module
  repository_data = module.repositories.repository_info
}
