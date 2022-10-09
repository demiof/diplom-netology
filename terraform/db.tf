resource "yandex_mdb_mysql_cluster" "db_cluster" {
  depends_on = [
    data.yandex_vpc_subnet.subnets_dpl_ru_central1_a
  ]
  name                = "my_db_cluster"
  environment         = "PRODUCTION"
  network_id          = data.yandex_vpc_network.network_dpl.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ]
  deletion_protection = true

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = "20"
  }


  host {
    name      = "db01"
    zone      = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.zone
    subnet_id = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.id
    assign_public_ip = false
    priority = 80
  }

  host {
    name      = "db02"
    replication_source_name = "db01"
    zone      = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.zone
    subnet_id = data.yandex_vpc_subnet.subnets_dpl_ru_central1_a.id
    assign_public_ip = false
    priority = 20
  }

}

resource "yandex_mdb_mysql_database" "db_wordpress" {
  cluster_id = yandex_mdb_mysql_cluster.db_cluster.id
  name       = "wordpress"
}


resource "yandex_mdb_mysql_user" "wordpress" {
  cluster_id = yandex_mdb_mysql_cluster.db_cluster.id
  name       = "wordpress"
  password   = "wordpress"
  permission {
    database_name = yandex_mdb_mysql_database.db_wordpress.name
    roles         = ["ALL"]
  }
}

resource "yandex_vpc_security_group" "mysql-sg" {
  name       = "mysql-sg"
  network_id = data.yandex_vpc_network.network_dpl.id

  ingress {
    description    = "MySQL"
    port           = 3306
    protocol       = "TCP"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}