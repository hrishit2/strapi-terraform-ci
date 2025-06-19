provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}
