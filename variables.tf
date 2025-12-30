variable "linode_pat" {
  type      = string
  sensitive = true
}

variable "root_pass" {
  type        = string
  sensitive   = true
  description = "Default root password for instances"
}
