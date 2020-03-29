variable "gitlab_runner_token" {
  type        = string
  description = "Token the gitlab-runner uses to register itself."
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
