# Input variables for the infopage module

variable "repository_data" {
  description = "Repository data from the repositories module"
  type = map(object({
    name      = string
    type      = string
    language  = string
    has_page  = bool
    repo_url  = string
    page_url  = string
    clone_url = string
  }))
}