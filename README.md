Description
===========

Installs and configures the latest version of (Shipper)[https://github.com/18f/shipper]. And provides a `shipper_config` LWRP.

Requirements
============

Platform
--------

* Debian, Ubuntu

Resource/Provider
=================

This cookbook includes LWRPs for managing shipper config files.

`shipper_config`
-----------------

Creates a Shipper configuration file at the path specified. And sets up a daemon
with the configuration created

# Actions

- :create: create a Shipper configuration file and daemon.
- :delete: delete an existing Shipper configuration file and daemon.

# Attribute Parameters

- project: name attribute. Name of the project being deployed.
- repository: github repository for the project.
- environment: the application environment. Default: `production`
- app_path: path to the application.
- app_user: user that owns the application path.
- server_id: unique id of the server. Default: Hash of the server ip.
- github_key: github API key to read and clone private repositories.
- shared_files: a hash of shared files. It takes the form of `{ from: 'to' }`.
- before_symlink: array of commands to run before symlinking.
- after_symlink: array of commands to run after symlinking.
- shipper_path: path to the shipper install directory. Default: `/etc/shipper`


# Example

    # create a config
    shipper_config "myproject" do
      repository "https://github.com/18f/shipper.git"
      environment "production"
      app_path deploy_to_dir
      app_user "user"
      github_key "foobar"
      shared_files {
        "config/database.yml" => "config/database.yml"
      }
      after_symlink [
        "touch tmp/restart.txt"
      ]
    end

Usage
=====

Simply include the recipe where you want Shipper installed.
