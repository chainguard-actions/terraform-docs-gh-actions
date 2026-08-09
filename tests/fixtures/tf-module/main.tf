variable "name" {
  description = "The name of the resource"
  type        = string
}

variable "count_value" {
  description = "Number of resources to create"
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to apply"
  type        = map(string)
  default     = {}
}

output "name" {
  description = "The name output"
  value       = var.name
}
