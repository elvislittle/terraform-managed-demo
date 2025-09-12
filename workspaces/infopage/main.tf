# Info page-only configuration
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

# Use remote state to get repository data from repos workspace
data "terraform_remote_state" "repos" {
  backend = "remote"
  
  config = {
    organization = "organization-elvislittle"
    workspaces = {
      name = "managed-repos-workspace"
    }
  }
}

# Call the infopage module with data from remote state
module "infopage" {
  source = "../../modules/infopage"

  # Use outputs from repos workspace remote state
  repository_data = data.terraform_remote_state.repos.outputs.repositories
}