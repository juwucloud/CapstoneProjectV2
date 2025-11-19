provider "aws" {
  region = var.region_us_west_2
}


provider "tls" {}
provider "local" {}