# Libvirt fedora coreos based gitlab runner 

This Terraform module provisions a gitlab runner inside a libvirt VM running
fedora coreos. `terraform-provider-libvirt` is used to create the VM and
volumes and an ignition file is created by the `terraform-provider-ct` in order
to setup the fedora coreos.

# Getting started

The easiest way to run the module is to use the
[terraform-libvirt-fcos-container](https://github.com/ingobecker/terraform-libvirt-fcos-container)
container image which includes all terraform-providers and tools required. See
the repos README.md for more informations on how to build and use it. Once you
have built the image perform the following steps in order to run the module:

```
$ git clone https://github.com/ingobecker/tf-libvirt-fcos-gitlab-runner.git
$ cd tf-libvirt-fcos-gitlab-runner
$ podman container runlabel run shell terraform-libvirt
```

This will drop you into a shell inside of the `terraform-libvirt` container
with the git repo mounted at `/home/deploy/src`. Running the following script
will download the latest `fedora coreos` image, decompress it and verify its
cryptographic signature:

```
[deploy@terrafom-libvirt]$ ./scripts/download_image.sh
```

The image will be placed into the `images` directory and `images/latest.qcow2`
will always point to the latest image available. Have a look at `variables.tf`
to see the available configuration options and create a `terraform.tfvars` which
fits your needs. You can start by using `terraform.tfvars.example`. You can look
up the required SHA256 checksum and released versions on the gitlab-runner
[release page](https://gitlab.com/gitlab-org/gitlab-runner/-/releases).

Now apply the terraform module:

```
[deploy@terraform-libvirt]$ terraform init
[deploy@terraform-libvirt]$ terraform apply
```

Review the changes and finally apply them by annswering with `yes`.

## Connect to the VM

Use the `ssh-command` output variable to get a ssh connection string:
```
[deploy@terraform-libvirt]$ terraform output ssh-command
```

Use the following command, to connect to the provisioned VM:
```
[deploy@terraform-libvirt]$ ssh $(terraform output ssh-command)
```
