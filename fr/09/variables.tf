variable "region" {
  description = "Region"
  type        = string
  default     = "europe-west1"
}



variable "project_id" {
  description = "Project id"
  type        = string
  default     = "subtle-builder-348511"
}

variable "instance_count" {
  description = "Number of instances to provision"
  type        = number
  default     = 2
}
