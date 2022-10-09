output "external_ipv4_address" {
  value = data.yandex_vpc_address.addr
}

# output "www" {
#   value = yandex_compute_instance.www
# }

output "my_subnets" {
  value = var.my_subnets
}

output "yc_cloud_id" {
  value = var.cloud_id
}

output "yc_folder_id" {
  value = var.folder_id_terraform_dpl_folder
}

output "network_dpl" {
  value = data.yandex_vpc_network.network_dpl
}

output "TF_VAR_subnets_dpl_ru_central1_a" {
  value = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a
}

output "TF_VAR_subnets_dpl_ru_central1_a_id" {
  value = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.id
}

# output "subnets_dpl_ru_central1_b" {
#   value = yandex_vpc_subnet.subnets_dpl_ru_central1_b
# }

# output "subnets_dpl_ru_central1_c" {
#   value = yandex_vpc_subnet.subnets_dpl_ru_central1_c
# }