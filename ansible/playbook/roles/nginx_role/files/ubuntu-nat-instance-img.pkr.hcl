
# YC Toolbox VM Image based on Ubuntu 18.04
#
# Yandex Packer provisioner docs:
# https://www.packer.io/docs/builders/yandex
#

variable "TF_VAR_folder_id_terraform_dpl_folder" {
  type            = string
  default         = env("TF_VAR_folder_id_terraform_dpl_folder")
}

variable "TF_VAR_tf_www_region" {
  type            = string
  default         = env("TF_VAR_tf_www_region")
}

variable "TF_VAR_vpc_subnets_dpl_ru_central1_a" {
  type            = string
  default         = env("TF_VAR_vpc_subnets_dpl_ru_central1_a")
}

variable "TF_VAR_ver" {
  type            = string
  default         = env("TF_VAR_ver")
}

variable "TF_VAR_tf_www_user" {
  type            = string
  default         = env("TF_VAR_tf_www_user")
}

variable "TF_VAR_token" {
  type            = string
  default         = env("TF_VAR_token")
}

variable "TF_VAR_subnets_dpl_ru_central1_a_id" {
  type            = string
  default         = env("TF_VAR_subnets_dpl_ru_central1_a_id")
}


source "yandex" "yc-toolbox" {
  instance_name       = "linktelru"
  instance_cores      = "2"
  instance_mem_gb     = "2"
  disk_type           = "network-ssd"
  folder_id           = "${var.TF_VAR_folder_id_terraform_dpl_folder}"
  image_family        = "ubuntu"
  image_description   = "by packer for link_tel.ru"
  image_name          = "ubuntu-18-04-nat-instance-linktelru"
  source_image_family = "nat-instance-ubuntu"
  subnet_id           = "${var.TF_VAR_subnets_dpl_ru_central1_a_id}"
  token               = "${var.TF_VAR_token}"
  use_ipv4_nat        = true
  zone                = "${var.TF_VAR_tf_www_region}"
  ssh_username        = "${var.TF_VAR_tf_www_user}"
}

build {
  
  sources = ["source.yandex.yc-toolbox"]

  provisioner "file" {
      source = "files/sshd_config"
      destination = "/home/ubuntu/sshd_config"
  }

  provisioner "shell" {
    inline = [
      "sleep 100",
      "sudo hostname link-tel.ru",
      "sudo apt-get update -y",
      "sudo apt-get install -y curl nginx certbot python3-certbot-nginx openssh-server",
      "sudo su -",
      "sudo mv /home/ubuntu/sshd_config /etc/ssh/sshd_config",
      "sudo mv /home/ubuntu/default /etc/nginx/sites-available/default",
      "sudo systemctl enable nginx.service",
      "curl localhost"

      ]
  }
}