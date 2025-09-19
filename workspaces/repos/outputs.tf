# =============================================================================
# REPOSITORIES WORKSPACE OUTPUTS
# =============================================================================
# This file defines outputs that expose data from this workspace to other
# workspaces via Terraform remote state data sources.
#
# Key Concepts:
# - Outputs make internal data available externally
# - Other workspaces can read these outputs using terraform_remote_state
# - This enables data sharing between isolated workspaces
# - The info page workspace reads this data to generate repository listings
# =============================================================================

# Repository information output
# Exposes detailed information about all created repositories
output "repositories" {
  description = "Complete repository information for consumption by other workspaces"

  # Value comes from the repositories module output
  # This contains details like repository names, URLs, pages status, etc.
  value = module.repositories.repository_info

  # Note: This output becomes available as:
  # data.terraform_remote_state.repos.outputs.repositories
  # in other workspaces that reference this workspace's state
}

# =============================================================================
# HOW REMOTE STATE SHARING WORKS:
# =============================================================================
# 1. This workspace (repos) creates repositories and outputs their data
# 2. HCP Terraform stores this output in the workspace's remote state
# 3. Other workspaces can read this data using terraform_remote_state:
#
#    data "terraform_remote_state" "repos" {
#      backend = "remote"
#      config = {
#        organization = "your-org"
#        workspaces = {
#          name = "managed-repos-workspace"
#        }
#      }
#    }
#
# 4. Access the data: data.terraform_remote_state.repos.outputs.repositories
# =============================================================================