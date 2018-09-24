# Get secrets from Conjur
provider "conjur" {}

# The top-level password for the database
data "conjur_secret" "db_password" {
  name = "tf-demo/db-password"
}

# The password the Rails app should use to access the database.
data "conjur_secret" "app_password" {
  name = "tf-demo/app-password"
}

# The db container, configured with a password from Conjur
resource "docker_container" "app_pg" {
  name = "app_pg"
  image = "${docker_image.postgres.latest}"
  networks = ["${var.demo_net}"]
  env = [
    "POSTGRES_PASSWORD=${data.conjur_secret.db_password.value}"
  ]
}

# The app's db user, also configured with a password from Conjur.
resource "null_resource" "createuser" {
  provisioner "local-exec" {
    command = "./bin/create_app_user ${docker_container.app_pg.name} tf_demo ${data.conjur_secret.app_password.value}"
  }
}

# The app container. Connects to the db as tf_demo, using the password stored in Conjur.
resource "docker_container" "app" {
  depends_on = ["null_resource.createuser"]
  name = "app"
  image = "tf-demo-app:latest"
  networks = ["${var.demo_net}"]
  env = [
    "TF_DEMO_DATABASE_PASSWORD=${data.conjur_secret.app_password.value}",
  ]
  ports {
    internal = 3000
    external = 3000
  }
}

resource "docker_image" "postgres" {
  name = "postgres:9.6"
  keep_locally = true
}

/*
 * docker provider always tries to pull the image, so can't do this
 * unless it lives in a registry
 *
resource "docker_image" "rails" {
  name = "tf-demo-app:latest"
  keep_locally = true
}
*/

