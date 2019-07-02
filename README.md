# Packer - Windows Server 2019

This build configuration installs and configures Windows Server 2019 (both Base and Core) x86_64 base image using a fairly standard preseed config file, some shell scripts, and Ansible, and then generates both a Vagrant box file for VirtualBox and an AWS AMI.

This can be modified to use more Ansible roles, plays, and included playbooks to fully configure (or partially) configure a box file suitable for deployment for development environments. By default, the image created will have Ansible and Docker pre-installed

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/)
  - [Ansible](http://docs.ansible.com/intro_installation.html)

> **Note**: By default, this config builds an AMI. For Packer to communicate with AWS, you must also setup your AWS access key and secret key using a [shared credential file](https://www.packer.io/docs/builders/amazon.html#specifying-amazon-credentials); remove the `amazon-ebs` builder from the Packer config or include the `-only=virtualbox-iso` flag when running a packer build.

> **Note**: This config includes a post-processor that pushes the template box to Vagrant Cloud. For this to work you must set a `VAGRANT_CLOUD_TOKEN` environment variable; remove the `vagrant-cloud` post-processor from the Packer config to build the box locally and not push it to Vagrant Cloud.

## Configuration Variables

Available variables are listed below:

version: ''

The version variable is used by Packer to help with tagging and naming. This is a cosmetic functionality to help you track you image version history. As seen below, this can be defined upon execution of the packer build command.  

profile: 'default'

The AWS profile to build the AMI using. As mentioned above, for Packer to communicate with AWS, you must also setup your AWS access key and secret key using a [shared credential file](https://www.packer.io/docs/builders/amazon.html#specifying-amazon-credentials). Unless overridden upon execution of the packer build command, we will use the credentials and config defined for your default profile,

## Usage

Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:

    $ packer build -var 'profile=customprofile' -var 'version=customversion' win2019-core.json

or

    $ packer build -var 'profile=customprofile' -var 'version=customversion' win2019-gui.json

After a few minutes, Packer should tell you the box was generated successfully, and the AMI was uploaded to AWS.

## Testing built boxes

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From this same directory, run the following command after building the box:

    $ vagrant up

> **Note**: If Vagrant runs into any issues mounting the VirtualBox shared folders, you can try to work around this issue by install the vagrant-vbguest plugin - `vagrant plugin install vagrant-vbguest`

## License

GNU GPL v3

## Author Information

Alex Carberry

## Future Features

  - Install virtualization quest tools
  - Compatible as an Ansible host (client)
  - "Cleanup"
  - "Debloat" the OS
  - Configure Windows Updates
  - Configure Windows Defender
  - Configure RDP
  - Manage UAC
  - Disable screensaver
