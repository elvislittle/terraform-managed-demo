# Outputs from the root module

# Output repository information
output "repositories" {
  description = "Information about created repositories"
  value       = module.repositories.repository_info
}

# Output info page repository information
output "info_page_repository" {
  description = "Info page repository URL"
  value       = module.infopage.repository_url
}

output "info_page_url" {
  description = "Info page GitHub Pages URL"
  value       = module.infopage.pages_url
}