terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 0.96.0"

  backend "s3" {

    endpoint                    = "storage.yandexcloud.net"
    key                         = "terraform.tfstate"
    bucket                      = "terraform-dpl-bucket"
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    access_key                  = "YCAJE4zCQpQ96dxmt1ghiPTfv"
    secret_key                  = "YCOZHFMAjk3dnr47SxZPW-ENtRNoYnw7Zs6QZcOe"

  }



}



