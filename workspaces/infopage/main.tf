# =============================================================================
# INFO PAGE WORKSPACE CONFIGURATION
# =============================================================================
# This file is executed by the "managed-info-page-workspace" in HCP Terraform.
# It's responsible for creating a GitHub repository that displays information
# about all the repositories managed by the repos workspace.
#
# Key Concepts:
# - This workspace runs from workspaces/infopage/ directory
# - It reads data from the repos workspace via remote state
# - It only handles info page creation (separation of concerns)
# - Triggered by changes to: workspaces/infopage/**/* or modules/infopage/**/*
# - Also triggered automatically when repos workspace completes (run trigger)
# =============================================================================

# Terraform configuration block
# Specifies required providers and their versions
terraform {
  required_providers {
    github = {
      source  = "integrations/github"  # Official GitHub provider
      version = "~> 6.0"                # Use version 6.x (allows minor updates)
    }
  }
}

# GitHub provider configuration
# Authenticates with GitHub API to manage the info page repository
provider "github" {
  # Authentication token is provided via GITHUB_TOKEN environment variable
  # This is set in HCP Terraform workspace variables for security
}

# =============================================================================
# REMOTE STATE DATA SOURCE
# =============================================================================
# Reads the output from the repos workspace to get repository information
# This enables cross-workspace data sharing in HCP Terraform
data "terraform_remote_state" "repos" {
  # Use the remote backend (HCP Terraform's state storage)
  backend = "remote"
  
  # Configuration for accessing the repos workspace state
  config = {
    organization = "organization-elvislittle"  # Your HCP Terraform organization
    workspaces = {
      name = "managed-repos-workspace"         # The source workspace name
    }
  }
  
  # Note: This workspace must be configured as a "remote state consumer"
  # in the repos workspace settings for this to work
}

# =============================================================================
# MODULE CALL - INFO PAGE CREATION
# =============================================================================
# Calls the infopage module to create a repository with information about
# all the repositories managed by the repos workspace
module "infopage" {
  # Path to the infopage module (relative to this file)
  # ../../ goes up two levels from workspaces/infopage/ to reach modules/
  source = "../../modules/infopage"

  # Pass repository data from the repos workspace
  # This data comes from the remote state of the repos workspace
  repository_data = data.terraform_remote_state.repos.outputs.repositories
}

# =============================================================================
# WORKSPACE EXECUTION FLOW:
# =============================================================================
# 1. Repos workspace runs first (creates repositories)
# 2. Repos workspace outputs repository data to its state
# 3. Run trigger automatically starts this info page workspace
# 4. This workspace reads repos data via terraform_remote_state
# 5. This workspace creates/updates the info page with current repo data
# 6. Result: Info page always reflects the current state of repositories
# =============================================================================

# =============================================================================
# HOW TO USE THIS WORKSPACE:
# =============================================================================
# 1. This workspace runs automatically via run triggers
# 2. To manually trigger: modify files in workspaces/infopage/ or modules/infopage/
# 3. To customize the info page: modify the infopage module
# 4. The info page will always show current repository information
# ============================================================================="