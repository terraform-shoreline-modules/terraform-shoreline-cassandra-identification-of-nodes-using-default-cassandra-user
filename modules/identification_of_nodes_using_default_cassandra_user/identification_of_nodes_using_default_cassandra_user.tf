resource "shoreline_notebook" "identification_of_nodes_using_default_cassandra_user" {
  name       = "identification_of_nodes_using_default_cassandra_user"
  data       = file("${path.module}/data/identification_of_nodes_using_default_cassandra_user.json")
  depends_on = [shoreline_action.invoke_update_cassandra_auth]
}

resource "shoreline_file" "update_cassandra_auth" {
  name             = "update_cassandra_auth"
  input_file       = "${path.module}/data/update_cassandra_auth.sh"
  md5              = filemd5("${path.module}/data/update_cassandra_auth.sh")
  description      = "Change the default username and password of the Cassandra database to a unique, complex, and secure one."
  destination_path = "/tmp/update_cassandra_auth.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_cassandra_auth" {
  name        = "invoke_update_cassandra_auth"
  description = "Change the default username and password of the Cassandra database to a unique, complex, and secure one."
  command     = "`chmod +x /tmp/update_cassandra_auth.sh && /tmp/update_cassandra_auth.sh`"
  params      = ["NEW_PASSWORD","NEW_USERNAME"]
  file_deps   = ["update_cassandra_auth"]
  enabled     = true
  depends_on  = [shoreline_file.update_cassandra_auth]
}

