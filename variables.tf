variable "gitlab_runner_register_args" {
  type        = map
  description = "Arguments passed to 'gitlab-runner register' command."
}

variable "ssh_key" {
  type        = string
  description = "ssh-key to access the provisioned fcos VM."
}

variable "user" {
  type        = string
  description = "User created on fcos VM. Use this account to login via ssh."
}

variable "password" {
  type        = string
  description = "Plaintext password for VM user."
}

variable "memory" {
  type        = number
  description = "RAM asigned to the VM."
}

variable "vcpus" {
  type        = number
  description = "VCPUs assigned to the VM."
}
