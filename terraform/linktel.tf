resource "yandex_compute_instance" "linktelru" {
  name      = "linktel"
  zone      = var.tf_www_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_18_04_nat_instance_linktelru_id

    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.id
    nat = true
    nat_ip_address = data.yandex_vpc_address.addr.external_ipv4_address[0].address
  }


  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }


}

