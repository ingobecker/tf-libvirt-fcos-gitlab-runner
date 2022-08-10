provider "ct" {
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  fcc_vars = {
    password                    = bcrypt(var.password)
    ssh_key                     = var.ssh_key
    user                        = var.user
    gitlab_runner_register_args = var.gitlab_runner_register_args
    gitlab_runner_version       = var.gitlab_runner_version
    gitlab_runner_sha_256       = var.gitlab_runner_sha_256
    gitlab_runners              = var.gitlab_runners
  }
}

resource "local_file" "fcc_debug" {
  content  = templatefile("${path.module}/content/fcc.yaml", local.fcc_vars)
  filename = "${path.module}/foo.yaml"
}

data "ct_config" "gitlab_runner_ign" {
  content      = templatefile("${path.module}/content/fcc.yaml", local.fcc_vars)
  pretty_print = true
}

resource "libvirt_ignition" "ignition" {
  name    = "ignition"
  content = data.ct_config.gitlab_runner_ign.rendered
}

resource "libvirt_volume" "fcos_stable" {
  name   = "fcos_stable"
  source = "${path.module}/images/latest.qcow2"
}

resource "libvirt_volume" "fcos_gitlab_runner" {
  name           = "fcos_gitlab_runner"
  base_volume_id = libvirt_volume.fcos_stable.id
  pool           = "default"
  format         = "qcow2"
  size           = var.storage * 1024 * 1024 * 1024
}

resource "libvirt_domain" "fcos_machine" {
  name            = "fcos_machine"
  vcpu            = var.vcpus
  memory          = var.memory
  coreos_ignition = libvirt_ignition.ignition.id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.fcos_gitlab_runner.id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }
}

output "ssh-command" {
  value       = "${var.user}@${libvirt_domain.fcos_machine.network_interface[0].addresses[0]}"
  description = "Reach your VM using this command"
}
