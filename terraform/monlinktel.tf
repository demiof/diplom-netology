resource "yandex_compute_instance" "monlinktel" {
  name      = "monlinktel"
  zone      = var.tf_www_region

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_22_04_instance_linktelru_id

    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.id
    nat = false
  }


  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }


}

