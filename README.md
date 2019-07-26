# README about *Vagrant* machine for *Sphinx*

Present project is a minimal directory structure to both
configure a [Vagrant] virtual machine (a [VirtualBox] one) with a fresh
[Sphinx] install, and serve as a [Sphinx] dedicated documentation project.

Documentation's content is in French.
Sources and *Sphinx*' outputs are equally stored on the repository,
so that people not running the box could directly access its content.
Only two output formats are supported/allowed:
HTML and PDF (generated by [LaTeX]).

| **Sphinx version**    | 2.1.x             |
| **Author**            | Vincent Férotin   |
| **License**           | BSD-style         |


## Dependencies

This *Vagrant* machine depends on:

*   [Vagrant],
*   [VirtualBox],
*   [Vagrant box](https://app.vagrantup.com/debian/boxes/buster64)
    for a 64bits [Debian] [Buster],
*   *sudo* with a specific configuration (see below),
*   [NFS].

Versions tested are:

*   host: *Debian* [Stretch]
*   *Vagrant* >= 2.2.5
*   *VirtualBox* >= 6.0
*   *debian/buster64* *Vagrant* box >= 10.0
*   *NFS* >= 3 && < 4, by the [Linux] kernel.


## Additional required configurations

NB: Following configuration should work for tested host, i.e. [Debian] [Stretch].
If your operating system differs, adapt these recommandations accordingly.


### VirtualBox network interface and Vagrant machine IP

In order to share project's root via [NFS] to the [Vagrant] virtual machine,
a dedicated [VirtualBox] network interface must be created and set.

Go to *VirtualBox* GUI and ensure that a dedicated network interface
is created for host-only network, for example *vboxnet1*.
Its IPv4 adress and subnet mask must match static IP set in *Vagrantfile*.
That is, if static IP in *Vagrantfile* is set to *192.168.57.3*,
*vboxnet1* must be set to *192.168.57.1* with a subnet mask to *255.255.255.0*.
[DHCP] must be deactivated.

NB: Using DHCP (with *type: "dhcp"*) seems to don't work for me
on [Ubuntu] [Disco] (19.04).


### Host firewall

Be sure that any firewall on your host is either shutdown,
or explicitely configured to allow traffic from and to network subnet linked to
the dedicated *VirtualBox* network interface.


### Users group

In order to give via *sudo* some specfic rights to load and use [NFS] server,
we could create a new users group, called *vagrant*, and put current user in
this new group:

```shell
# Create new 'vagrant' group
$ sudo addgroup vagrant
# Put your username in this group
$ sudo adduser <USERNAME> vagrant
```

NB: You must re-log for this change to be taken into account!


### NFS service

[NFS] server by [Linux] kernel is not provided by default on [Debian]:
you need to install additional *nfs-kernel-server* package, and configure
its related service:

```shell
# Install package
$ sudo apt install nfs-kernel-server
# Configure NFS service to not be started at O.S. startup
$ sudo systemctl disable nfs-kernel-server
```

### sudo

As [Vagrant] documentation states, [NFS] sharing needs some special root
privileges (https://www.vagrantup.com/docs/synced-folders/nfs.html#root-privilege-requirement).
A good practice to do that is using *sudo*.

First, ensure *sudo* package is installed:

```shell
# Install package
$ sudo apt install sudo
```

NB: You probably need to restart the host operating system, for allowing *sudo*
to work!

Now that our new *vagrant* users group is created, its easy to configure *sudo*
as following, for allowing commands to be run by its users without requiring
password prompt:

```shell
$ sudo visudo
```

```plaintext
User_Alias VAGRANT_USERS = %vagrant

# Please take care of actual full-paths to binaries,
# and adapt them according your current distribution!
Cmnd_Alias VAGRANT_EXPORTS_CHOWN = /bin/chown 0\:0 /tmp/*
Cmnd_Alias VAGRANT_EXPORTS_MV    = /bin/mv -f /tmp/* /etc/exports
Cmnd_Alias VAGRANT_NFSD_CHECK    = /bin/systemctl status nfs-kernel-server
Cmnd_Alias VAGRANT_NFSD_START    = /bin/systemctl start nfs-kernel-server
Cmnd_Alias VAGRANT_NFSD_STOP     = /bin/systemctl stop nfs-kernel-server
Cmnd_Alias VAGRANT_NFSD_RESTART  = /bin/systemctl restart nfs-kernel-server
Cmnd_Alias VAGRANT_NFSD_APPLY    = /usr/sbin/exportfs -ar
Cmnd_Alias VAGRANT_HOSTS_ADD     = /bin/sh -c echo "*" >> /etc/hosts
Cmnd_Alias VAGRANT_HOSTS_REMOVE  = /bin/sed -i -e /*/ d /etc/hosts

VAGRANT_USERS ALL=(root) NOPASSWD: VAGRANT_EXPORTS_CHOWN, VAGRANT_EXPORTS_MV, VAGRANT_NFSD_CHECK, VAGRANT_NFSD_START, VAGRANT_NFSD_STOP, VAGRANT_NFSD_RESTART, VAGRANT_NFSD_APPLY, VAGRANT_HOSTS_ADD, VAGRANT_HOSTS_REMOVE
```


## Usage

Usage of the virtual machine should now be relatively easy:

```shell
# Start NFS server
$ sudo systemctl start nfs-kernel-server
# Virtual machine creation and initialization
$ cd /path/to/repo/vagrant-sphinx
$ vagrant up
# Go into virtual machine with SSH
$ vagrant ssh
# Inside virtual machine:
#   Change current directory to this shared by Vagrant,
#   i.e. /path/to/repo/vagrant-sphinx root
vagrant@sphinx-2.1$ cd /vagrant
#   Activate Sphinx virtualenv
vagrant@sphinx-2.1$ source /opt/sphinx-2.1/bin/activate
#   See Makefile help
vagrant@sphinx-2.1$ make [help]
#   Only four targets are available: 'html', 'pdf', 'clean' and 'all'
#     Generate HTML output for example
vagrant@sphinx-2.1$ make html
#       See updated content in /path/to/repo/vagrant-sphinx/html directory
```


## Use present project as a template

This project and its directory structure could be used as a template
for another new documentation project.
Ensure, after copying directory content, to:

*   change vagrant virtual machine's name:
    it is controlled in the *Vagrantfile* by **@vm_name** variable;
*   adapt [Sphinx] configuration in *src/conf.py*, notably:
    **project** and **project_short_name** variables.


[Buster]:               https://www.debian.org/releases/buster/
[Debian]:               https://www.debian.org/
[debian-buster-box]:    https://app.vagrantup.com/debian/boxes/buster64
[DHCP]:                 https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol
[Disco]:                http://releases.ubuntu.com/disco/
[LaTeX]:                https://www.latex-project.org/
[Linux]:                https://en.wikipedia.org/wiki/Linux_kernel
[NFS]:                  https://en.wikipedia.org/wiki/Network_File_System_%28protocol%29
[Sphinx]:               https://www.sphinx-doc.org/
[Stretch]:              https://www.debian.org/releases/stretch/
[Ubuntu]:               https://ubuntu.com/
[Vagrant]:              https://www.vagrantup.com/
[VirtualBox]:           https://www.virtualbox.org/

