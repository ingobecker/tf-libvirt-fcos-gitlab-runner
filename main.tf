provider "ct" {
}

provider "libvirt" {
  uri = "qemu:///system"
}

data "template_file" "gitlab_runner_fcc" {
  template = file("${path.module}/content/fcc.yaml")

  vars = {
    password            = bcrypt(var.password)
    ssh_key             = var.ssh_key
    user                = var.user
    gitlab_runner_token = var.gitlab_runner_token
  }
}

data "ct_config" "gitlab_runner_ign" {
  content      = data.template_file.gitlab_runner_fcc.rendered
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
    network_name = "default"
  }
}
