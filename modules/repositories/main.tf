# Repositories module - creates actual GitHub repositories

# Create GitHub repositories
resource "github_repository" "repository" {
  for_each = var.repos

  name        = "${each.key}-repo"
  description = "${each.value.type} repository using ${each.value.language}"
  visibility  = "public"
  auto_init   = true

  # Enable GitHub Pages if specified
  dynamic "pages" {
    for_each = each.value.has_page ? [1] : []
    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }
}

# Create README files for each repository
resource "github_repository_file" "readme" {
  for_each = var.repos

  repository = github_repository.repository[each.key].name
  branch     = "main"
  file       = "README.md"

  content = <<-EOT
    # ${each.key} Repository
    
    **Type:** ${each.value.type}
    **Language:** ${each.value.language}
    **Has Page:** ${each.value.has_page ? "Yes" : "No"}
    
    This repository was created using Terraform as a demonstration.
    
    ## Getting Started
    
    This is a ${each.value.language} ${each.value.type} project.
    
    %{if each.value.has_page~}
    Visit the GitHub Pages site for this repository to see it in action.
    %{endif~}
  EOT

  overwrite_on_create = true
}

# Create a main file for each repository based on language
resource "github_repository_file" "main_file" {
  for_each = var.repos

  repository = github_repository.repository[each.key].name
  branch     = "main"
  file       = local.main_files[each.value.language]

  content = local.file_contents[each.value.language]

  overwrite_on_create = true
}

# Local values for file names and content based on language
locals {
  main_files = {
    python     = "main.py"
    javascript = "index.js"
    terraform  = "main.tf"
    markdown   = "docs.md"
  }

  file_contents = {
    python = <<-EOT
      #!/usr/bin/env python3
      """
      Main Python file for this repository
      """
      
      def main():
          print("Hello from Python!")
      
      if __name__ == "__main__":
          main()
    EOT

    javascript = <<-EOT
      // Main JavaScript file for this repository
      
      function main() {
          console.log("Hello from JavaScript!");
      }
      
      // Run if this is the main module
      if (require.main === module) {
          main();
      }
      
      module.exports = { main };
    EOT

    terraform = <<-EOT
      # Main Terraform configuration
      
      terraform {
        required_version = ">= 1.0"
      }
      
      # Example resource
      resource "null_resource" "example" {
        provisioner "local-exec" {
          command = "echo 'Hello from Terraform!'"
        }
      }
    EOT

    markdown = <<-EOT
      # Documentation
      
      This is a documentation repository created with Terraform.
      
      ## Contents
      
      - Project documentation
      - API references
      - User guides
      
      ## Getting Started
      
      Welcome to the documentation repository!
    EOT
  }
}
