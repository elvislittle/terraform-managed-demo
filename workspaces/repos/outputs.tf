# Output repository information for remote state access
output "repositories" {
  description = "Repository information for info page"
  value       = module.repositories.repository_info
}