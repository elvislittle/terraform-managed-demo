# Input variables for the repositories module

variable "repos" {
  description = "Map of repositories to create with their configuration"
  type = map(object({
    type     = string
    language = string
    has_page = bool
  }))
}