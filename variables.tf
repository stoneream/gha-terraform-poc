variable "linode_pat" {
  type      = string
  sensitive = true
}

variable "instance_default_root_pass" {
  type        = string
  sensitive   = true
  description = "Default root password for instances"
}
