# Outputs from the repositories module

# Output repository information for use by other modules
output "repository_info" {
  description = "Information about all created repositories"
  value = {
    for name, config in var.repos : name => {
      name     = name
      type     = config.type
      language = config.language
      has_page = config.has_page
      # Real repository URL
      repo_url = github_repository.repository[name].html_url
      # Real page URL (only if has_page is true)
      page_url = config.has_page ? try(github_repository.repository[name].pages[0].html_url, "Pending") : null
      # Clone URL
      clone_url = github_repository.repository[name].git_clone_url
    }
  }
}

# Output count of repositories
output "repository_count" {
  description = "Total number of repositories created"
  value       = length(var.repos)
}

# Output repository names
output "repository_names" {
  description = "Names of all created repositories"
  value       = [for repo in github_repository.repository : repo.name]
}