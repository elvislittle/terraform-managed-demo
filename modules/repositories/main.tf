# =============================================================================
# REPOSITORIES MODULE
# =============================================================================
# This module creates GitHub repositories with standardized configurations.
# It's designed to be reusable and creates repositories based on input variables.
#
# Key Features:
# - Creates GitHub repositories with consistent naming
# - Adds README files with repository information
# - Creates language-specific starter files
# - Optionally enables GitHub Pages
# - Outputs repository information for other modules/workspaces
# =============================================================================

# =============================================================================
# GITHUB REPOSITORIES
# =============================================================================

# Create GitHub repositories based on the input configuration
# Uses for_each to create multiple repositories from a map
resource "github_repository" "repository" {
  # Iterate over each repository definition in var.repos
  for_each = var.repos

  # Repository configuration
  name        = "${each.key}-repo"                                    # Repository name with suffix
  description = "${each.value.type} repository using ${each.value.language}"  # Auto-generated description
  visibility  = "public"                                             # Make repository public
  auto_init   = true                                                  # Initialize with empty commit

  # Conditionally enable GitHub Pages based on repository configuration
  # Uses dynamic block to include pages configuration only when needed
  dynamic "pages" {
    # Create pages block only if has_page is true
    for_each = each.value.has_page ? [1] : []
    content {
      source {
        branch = "main"    # Serve pages from main branch
        path   = "/"       # Serve from root directory
      }
    }
  }
  
  # Repository features
  has_issues   = true     # Enable issue tracking
  has_wiki     = false    # Disable wiki
  has_projects = false    # Disable projects
}

# =============================================================================
# README FILES
# =============================================================================

# Create README.md files for each repository
# Provides consistent documentation across all repositories
resource "github_repository_file" "readme" {
  # Create one README per repository
  for_each = var.repos

  # File location and metadata
  repository = github_repository.repository[each.key].name  # Reference created repository
  branch     = "main"                                       # Target branch
  file       = "README.md"                                  # File name

  # README content using template syntax
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
    
    ## Repository Information
    
    - **Created by:** Terraform
    - **Managed by:** HCP Terraform
    - **Module:** repositories
    
    ## Development
    
    This repository includes starter files for ${each.value.language} development.
    Check the main file for language-specific examples and best practices.
  EOT

  # File management options
  overwrite_on_create = true    # Replace file if it exists during creation
}

# =============================================================================
# LANGUAGE-SPECIFIC STARTER FILES
# =============================================================================

# Create main development files based on the repository's programming language
# Provides a starting point for development in each repository
resource "github_repository_file" "main_file" {
  # Create one main file per repository
  for_each = var.repos

  # File location and metadata
  repository = github_repository.repository[each.key].name     # Reference created repository
  branch     = "main"                                          # Target branch
  file       = local.main_files[each.value.language]          # Language-specific filename

  # File content from language-specific templates
  content = local.file_contents[each.value.language]

  # File management options
  overwrite_on_create = true    # Replace file if it exists during creation
}

# =============================================================================
# LOCAL VALUES - LANGUAGE CONFIGURATIONS
# =============================================================================

# Define language-specific configurations
# Maps programming languages to their appropriate file names and starter content
locals {
  # Map programming languages to their main file names
  main_files = {
    python     = "main.py"      # Python entry point
    javascript = "index.js"     # JavaScript entry point
    terraform  = "main.tf"      # Terraform configuration
    markdown   = "docs.md"      # Documentation file
    java       = "Main.java"    # Java main class
    go         = "main.go"      # Go entry point
    rust       = "main.rs"      # Rust entry point
  }

  # Language-specific starter file contents
  # Each provides a basic example and best practices for the language
  file_contents = {
    # Python starter file with basic structure
    python = <<-EOT
      #!/usr/bin/env python3
      """
      Main Python file for this repository
      
      This is a starter template for Python development.
      Includes basic structure and best practices.
      """
      
      def main():
          """Main function - entry point of the application."""
          print("Hello from Python!")
          print("Repository created with Terraform")
          
          # Add your application logic here
          
      def example_function():
          """Example function demonstrating Python best practices."""
          return "This is an example function"
      
      if __name__ == "__main__":
          main()
    EOT

    # JavaScript starter file with Node.js structure
    javascript = <<-EOT
      // Main JavaScript file for this repository
      // Node.js application starter template
      
      /**
       * Main function - entry point of the application
       */
      function main() {
          console.log("Hello from JavaScript!");
          console.log("Repository created with Terraform");
          
          // Add your application logic here
      }
      
      /**
       * Example function demonstrating JavaScript best practices
       * @returns {string} Example message
       */
      function exampleFunction() {
          return "This is an example function";
      }
      
      // Run if this is the main module
      if (require.main === module) {
          main();
      }
      
      // Export functions for use in other modules
      module.exports = { 
          main, 
          exampleFunction 
      };
    EOT

    # Terraform starter file with basic configuration
    terraform = <<-EOT
      # Main Terraform configuration
      # Infrastructure as Code starter template
      
      terraform {
        required_version = ">= 1.0"
        
        required_providers {
          # Add required providers here
          # Example:
          # aws = {
          #   source  = "hashicorp/aws"
          #   version = "~> 5.0"
          # }
        }
      }
      
      # Example resource - replace with your actual infrastructure
      resource "null_resource" "example" {
        provisioner "local-exec" {
          command = "echo 'Hello from Terraform!'"
        }
        
        provisioner "local-exec" {
          command = "echo 'Repository created with Terraform'"
        }
      }
      
      # Example output
      output "message" {
        description = "Example output from Terraform"
        value       = "This repository was created using Terraform"
      }
    EOT

    # Markdown documentation starter
    markdown = <<-EOT
      # Documentation Repository
      
      This is a documentation repository created with Terraform.
      
      ## Overview
      
      This repository contains documentation for the project.
      It was automatically created and configured using Infrastructure as Code.
      
      ## Contents
      
      - Project documentation
      - API references  
      - User guides
      - Development guidelines
      
      ## Getting Started
      
      Welcome to the documentation repository!
      
      ### Structure
      
      ```
      docs/
      ├── api/          # API documentation
      ├── guides/       # User guides
      ├── development/  # Development docs
      └── assets/       # Images and other assets
      ```
      
      ## Contributing
      
      1. Fork the repository
      2. Create a feature branch
      3. Make your changes
      4. Submit a pull request
      
      ## Maintenance
      
      This repository is managed by Terraform.
      Infrastructure changes should be made through the Terraform configuration.
    EOT

    # Java starter file with basic class structure
    java = <<-EOT
      /**
       * Main Java class for this repository
       * Java application starter template
       */
      public class Main {
          
          /**
           * Main method - entry point of the application
           * @param args Command line arguments
           */
          public static void main(String[] args) {
              System.out.println("Hello from Java!");
              System.out.println("Repository created with Terraform");
              
              // Create instance and call example method
              Main app = new Main();
              String result = app.exampleMethod();
              System.out.println(result);
          }
          
          /**
           * Example method demonstrating Java best practices
           * @return Example message
           */
          public String exampleMethod() {
              return "This is an example method";
          }
      }
    EOT

    # Go starter file with basic structure
    go = <<-EOT
      // Main Go file for this repository
      // Go application starter template
      
      package main
      
      import (
          "fmt"
      )
      
      // main function - entry point of the application
      func main() {
          fmt.Println("Hello from Go!")
          fmt.Println("Repository created with Terraform")
          
          // Call example function
          message := exampleFunction()
          fmt.Println(message)
      }
      
      // exampleFunction demonstrates Go best practices
      func exampleFunction() string {
          return "This is an example function"
      }
    EOT

    # Rust starter file with basic structure
    rust = <<-EOT
      // Main Rust file for this repository
      // Rust application starter template
      
      /// Main function - entry point of the application
      fn main() {
          println!("Hello from Rust!");
          println!("Repository created with Terraform");
          
          // Call example function
          let message = example_function();
          println!("{}", message);
      }
      
      /// Example function demonstrating Rust best practices
      fn example_function() -> String {
          String::from("This is an example function")
      }
      
      #[cfg(test)]
      mod tests {
          use super::*;
          
          #[test]
          fn test_example_function() {
              let result = example_function();
              assert_eq!(result, "This is an example function");
          }
      }
    EOT
  }
}

# =============================================================================
# MODULE USAGE EXAMPLES:
# =============================================================================
# This module can be called with different repository configurations:
#
# module "repositories" {
#   source = "./modules/repositories"
#   
#   repos = {
#     my_api = {
#       type     = "backend"
#       language = "python"
#       has_page = false
#     }
#     my_frontend = {
#       type     = "frontend"
#       language = "javascript"
#       has_page = true
#     }
#   }
# }
# ============================================================================="