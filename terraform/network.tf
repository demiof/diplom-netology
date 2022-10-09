data "yandex_iam_service_account" "sa" {
  name = "tf-diplom"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  role      = "storage.editor"
  member    = "serviceAccount:${data.yandex_iam_service_account.sa.id}"
  folder_id = var.folder_id_terraform_dpl_folder
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = data.yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
# resource "yandex_storage_bucket" "terraform-dpl-bucket" {
#   access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#   secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#   bucket    = var.tf_state_bucket
#   folder_id = var.folder_id_terraform_dpl_folder
# }


# Network
data "yandex_vpc_network" "network_dpl" {
  name = "network_dpl"
}

data "yandex_vpc_subnet" "subnets_dpl_ru_central1_a" {

#  zone           = "ru-central1-a"
#  v4_cidr_blocks = var.my_subnets.a.ru_central1_a
  name           = format("subnet_dpl_%s", var.my_subnets.a.ru_central1_a[0])

#  network_id = data.yandex_vpc_network.network_dpl.id
}

# resource "yandex_vpc_subnet" "subnets_dpl_ru_central1_b" {

#   zone           = "ru-central1-b"
#   v4_cidr_blocks = var.my_subnets.b.ru_central1_b
#   name           = format("subnet_dpl_%s", var.my_subnets.b.ru_central1_b[0])

#   network_id = yandex_vpc_network.network_dpl.id
# }

# resource "yandex_vpc_subnet" "subnets_dpl_ru_central1_c" {

  
#   zone           = "ru-central1-c"
#   v4_cidr_blocks = var.my_subnets.c.ru_central1_c
#   name           = format("subnet_dpl_%s", var.my_subnets.c.ru_central1_c[0])

#   network_id = yandex_vpc_network.network_dpl.id

# }

data "yandex_vpc_address" "addr" {
  name = "pub_ipv4"

  # external_ipv4_address {
  #   zone_id = "ru-central1-a"
  #   ddos_protection_provider = "qrator"
  # }
}


#resource "yandex_compute_image" "test" {
#  name       = "my-ubuntu-amd64"
#  source_url = "https://packages.debian.org/sid/linux-image-amd64"
#  image_id = var.ubuntu-22-04-live-server-amd64-www-id
#  source_url = "${var.ubuntu-srv-amd64}"
#}

resource "yandex_vpc_security_group" "my-sg" {
  name        = "My security group"
  description = "Description for security group"
  network_id  = data.yandex_vpc_network.network_dpl.id

  ingress {
    protocol       = "ANY"
    description    = "Rule description 1"
    v4_cidr_blocks = ["194.152.34.0/23", "176.111.72.0/21"]
#    port           = 8080
  }

  # egress {
  #   protocol       = "ANY"
  #   description    = "Rule description 2"
  #   v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  #   from_port      = 8090
  #   to_port        = 8099
  # }
}