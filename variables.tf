variable "gitlab_runner_version" {
  type        = string
  description = "Versions of the gitlab runner to download"
}

variable "gitlab_runner_sha_256" {
  type        = string
  description = "Checksum of the gitlab runner binary"
}

variable "gitlab_runner_register_args" {
  type        = map(any)
  description = "Arguments passed to 'gitlab-runner register' command."
}

variable "gitlab_runners" {
  type = list(map(any))
  description = "For each entry, call 'gitlab-runner register', add register_args and this runner specific args"
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

variable "storage" {
  type        = number
  description = "Size of the volume assigned to the VM in GB."
}
