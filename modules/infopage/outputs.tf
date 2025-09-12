# Outputs from the infopage module

# Output the repository URL
output "repository_url" {
  description = "URL of the info page repository"
  value       = github_repository.info_page.html_url
}

# Output the GitHub Pages URL
output "pages_url" {
  description = "URL of the GitHub Pages for info page"
  value       = try(github_repository.info_page.pages[0].html_url, "Pending")
}
