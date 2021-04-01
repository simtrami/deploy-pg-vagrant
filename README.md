# deploy-pg-vagrant

This repository contains a Vagrantfile which installs and starts a PostgreSQL 12 server in a virtual machine and exposes it to `localhost` on port `tcp/54321`.
It is not meant to be used in production environment but for development or testing only.

>If you plan on using this for a PHP project (Symfony, Laravel, etc.), consider using the excellent [Laravel Homestead](https://laravel.com/docs/homestead) instead of this.

## Requirements

- [Vagrant](https://www/vagrantup.com/downloads) (tested with v2.2.14)
- Any Vagrant [provider](https://www.vagrantup.com/docs/providers), [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is recommended for anyone (tested with v6.1.18r142142)
- A virtualization capable machine (ask your favorite search engine to know more)

This will work on any system capable to run the latest Vagrant and Virtualbox: Ubuntu or any recent distro, MacOS and Windows.

## Usage

Run the following commands in your terminal.

First copy the repository and move into it.

```sh
git clone https://github.com/simtrami/deploy-pg-vagrant.git
cd deploy-pg-vagrant
```

>*(Optional)* Change the database name, username and/or password by editing the first lines of `after.sh`.

*(Optional)* Copy `Vagrantfile` and `after.sh` to your project's folder so that you can use the vagrant CLI without leaving your project's directory.

```sh
cp Vagrantfile /your/project
cp after.sh /your/project
cd /your/project
```

Provision and start the Vagrant box.

>You can change its name (*pg12* by default) by replacing every `pg12` by what you prefer in `Vagrantfile`.

```sh
vagrant up
```

After it's done, you should be prompted what to do next for using your newly created PG server.

### Stopping and removing

Before shutting down your computer, remember to `vagrant halt` you virtual machine in order to not break anything.

If you want to completely remove the machine from your computer, run `vagrant destroy` from the directory parent to *.vagrant*.

## Going further

If you have other plans for your virtual machine and if you want to interact with its system, you can SSH into it with `vagrant ssh`.  
And if you want to rely on the SSH access for other purposes (such as copying a file via SCP), you can generate the SSH configuration for accessing your box with `vagrant ssh-config`.
Copy the output to your `~/.ssh/config` file of use it to write a beautiful (but unreadable) command line.

Check out the Vagrant [documentation](https://www.vagrantup.com/docs) to become a pro.
