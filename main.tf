terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "identification_of_nodes_using_default_cassandra_user" {
  source    = "./modules/identification_of_nodes_using_default_cassandra_user"

  providers = {
    shoreline = shoreline
  }
}