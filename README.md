# terraform-conjur-demo

A demo showing the use of the [Conjur Terraform
provider](https://github.com/cyberark/terraform-provider-conjur).

## Introduction

This demo shows how to use Terraform to manage a set of Docker containers that store their
secrets in Conjur. In the demo, the Docker containers combine to create simple Rails app
backed by a PostgreSQL database. The master database password, as well as
the password for the Rails database user, are stored in Conjur.

## Usage

Scripts in this directory are meant to be run in numerical order:

* [00_start](00_start)

Fetches the Conjur Terraform provider from GitHub, calls `terraform init` to get ready to
use it.

Uses `docker-compose` to start a Conjur server, with data stored in a Postgres instance
(separate from the instance that will be started for the app).

* [01_run_app](01_run_app)

Builds the Rails app's docker image, then uses `terraform apply` to deploy the app. Once it
has started, visit http://localhost:3000 to see it in action.

* [02_refresh_app](02_refresh_app)

Run this script to rebuild and redeploy the Rails app after making changes to it.

* [03_rotate_app_password](03_rotate_app_password)

Have Conjur generate a new password for the app's database user, and redeploy the Rails app
using it

* [98_destroy_app](98_destroy_app)

Uses `terraform destroy` to destroy the app's containers. All application data will be
deleted.

After calling 98_destroy_app, you must use 01_run_app to start a new instance of the app.

* [99_destroy_conjur](99_destroy_conjur)

Uses `docker-compose` to destroy the Conjur containers. All application secrets will be
deleted.

After calling 99_destroy_conjur, you must start again with 00_start_conjur before
deploying the app again.
