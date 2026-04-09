variable "image" {}

terraform {
  backend "s3" {
    bucket         = "valdevops-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "dev_app" {
  source   = "./modules/app"
  app_name = "my-app"
  env      = "dev"
  image    = var.image
}

module "prod_app" {
  source   = "./modules/app"
  app_name = "my-app"
  env      = "prod"
  image    = var.image
}

module "ingress" {
  source = "./modules/ingress"

  rules = [
    {
      host         = "dev.myapp.local"
      service_name = module.dev_app.service_name
      service_port = 80
    },
    {
      host         = "prod.myapp.local"
      service_name = module.prod_app.service_name
      service_port = 80
    }
  ]
}

