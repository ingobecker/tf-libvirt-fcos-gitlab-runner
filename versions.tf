terraform {
  required_version = "~> 1.2.6"
  required_providers {

    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }

    ct = {
      source  = "poseidon/ct"
      version = "0.11.0"
    }

    local    = "~> 1.2"
    template = "~> 2.1"
  }
}
