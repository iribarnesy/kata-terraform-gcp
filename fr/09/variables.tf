variable "region" {
  description = "Region"
  type        = string
  default     = "europe-west1"
}

variable "project_id" {
  description = "Project id"
  type        = string
  default     = "kata-terraform-gcp"
}

variable "instance_count" {
  description = "Number of instances to provision"
  type        = number
  default     = 2
}
