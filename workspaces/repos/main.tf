# =============================================================================
# REPOSITORIES WORKSPACE CONFIGURATION
# =============================================================================
# This file is executed by the "managed-repos-workspace" in HCP Terraform.
# It's responsible for creating and managing GitHub repositories.
#
# Key Concepts:
# - This workspace runs from workspaces/repos/ directory
# - It only handles repository creation (separation of concerns)
# - Repository data is exposed via outputs.tf for other workspaces
# - Triggered by changes to: workspaces/repos/**/* or modules/repositories/**/*
# =============================================================================

# Terraform configuration block
# Specifies required providers and their versions
terraform {
  required_providers {
    github = {
      source  = "integrations/github" # Official GitHub provider
      version = "~> 6.0"              # Use version 6.x (allows minor updates)
    }
  }
}

# GitHub provider configuration
# Authenticates with GitHub API to manage repositories
provider "github" {
  # Authentication token is provided via GITHUB_TOKEN environment variable
  # This is set in HCP Terraform workspace variables for security
  # Alternative: token = var.github_token (if using Terraform variables)
}

# =============================================================================
# REPOSITORY DEFINITIONS
# =============================================================================
# Local values define the repositories to be created
# This is the "source of truth" for what repositories should exist
locals {
  # Each repository is defined with its properties
  # Key = repository identifier, Value = repository configuration
  repositories = {
    # Backend API repository
    test_api = {
      type     = "backend" # Repository category/type
      language = "python"  # Primary programming language
      has_page = true      # Whether to enable GitHub Pages
    }
    # Frontend web application repository
    test_web = {
      type     = "frontend"   # Repository category/type
      language = "javascript" # Primary programming language
      has_page = true         # Whether to enable GitHub Pages
    }
    test_infra = {
      type     = "infrastructure"
      language = "terraform"
      has_page = true
    }
    # Add more repositories here as needed:
    # new_repo = {
    #   type     = "mobile"
    #   language = "swift"
    #   has_page = true
    # }
  }
}

# =============================================================================
# MODULE CALL - REPOSITORY CREATION
# =============================================================================
# Calls the repositories module to actually create the GitHub repositories
# The module contains the logic for creating repos, files, and configurations
module "repositories" {
  # Path to the repositories module (relative to this file)
  # ../../ goes up two levels from workspaces/repos/ to reach modules/
  source = "../../modules/repositories"

  # Pass the repository definitions to the module
  # The module will iterate over this map to create each repository
  repos = local.repositories
}

# =============================================================================
# HOW TO USE THIS FILE:
# =============================================================================
# 1. To add a new repository:
#    - Add a new entry to the locals.repositories map
#    - Commit and push changes
#    - HCP Terraform will automatically create the repository
#
# 2. To modify a repository:
#    - Update the repository's properties in locals.repositories
#    - Commit and push changes
#    - HCP Terraform will update the repository
#
# 3. To remove a repository:
#    - Remove the entry from locals.repositories
#    - Commit and push changes
#    - HCP Terraform will destroy the repository
# =============================================================================
