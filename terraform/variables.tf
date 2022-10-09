variable "token" {
  sensitive = true
}

variable "access_key" {
  sensitive = true
}

variable "secret_key" {
  sensitive = true
}

variable "access_key_terraform_dpl_folder" {
  sensitive = true
}

variable "secret_key_terraform_dpl_folder" {
  sensitive = true
}

variable "tf_state_bucket" {
}

variable "tf_state_region" {
}

variable "cloud_id" {
}

variable "folder_id" {
  sensitive = true
}

variable "folder_id_terraform_dpl_folder" {
}

variable "tf_www_region" {
  sensitive = true
}


variable "vpc_network" {
}

variable "my_subnets" {
  description = "my zones & my subnets"
  type        = map(map(list(string)))
  default = {
    a = { 
          ru_central1_a = ["192.168.111.0/24",]
        }
    b = { 
          ru_central1_b = ["192.168.112.0/24",]
        }
    c = { 
          ru_central1_c = ["192.168.110.0/24",]
        }
  }
}

variable "ubuntu_22_04_instance_linktelru_id" {
}

variable "ubuntu_18_04_nat_instance_linktelru_id" {
}

