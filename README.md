# Libvirt fedora coreos based gitlab runner 

This Terraform module provisions a gitlab runner inside a libvirt VM running
fedora coreos. `terraform-provider-libvirt` is used to create the VM and
volumes and an ignition file is created by the `terraform-provider-ct` in order
to setup the fedora coreos.

The provisioned VM comes with support for the gitlabs experimental
[podman executor](https://docs.gitlab.com/runner/executors/docker.html#use-podman-to-run-docker-commands-beta)
enabled by default. Podmans socket/service for the `gitlab-runner` user is enabled
by default as a user unit using lingering.

You can also configure multiple runners running on one VM with different executors
via the `gitlab_runners` [input variable](https://github.com/ingobecker/tf-libvirt-fcos-gitlab-runner/blob/master/terraform.tfvars.example#L14).

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

## Security

Using the podman in podman executor as outlined in the
[terraform.tfvars.example](https://github.com/ingobecker/tf-libvirt-fcos-gitlab-runner/blob/7e3115055ca08fef26edcaccffdd6714ba4cd176/terraform.tfvars.example#L32)
requires some additional capabilities and disables SELinux labels which makes
this executor less secure than a normal podman executor or podman executed from
the shell executor. Altough the podman which is running inside the podman is
secure, keep in mind that running potentially harmfull 3rd party images for the
outer podman might be dangerous.
