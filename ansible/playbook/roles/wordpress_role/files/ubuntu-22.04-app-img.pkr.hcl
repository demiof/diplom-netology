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
  instance_name       = "applinktelru"
  instance_cores      = "4"
  instance_mem_gb     = "4"
  disk_type           = "network-ssd"
  folder_id           = "${var.TF_VAR_folder_id_terraform_dpl_folder}"
  image_family        = "ubuntu"
  image_description   = "by packer for www.link_tel.ru"
  image_name          = "ubuntu-22-04-instance-linktelru"
  source_image_family = "ubuntu-2204-lts"
  subnet_id           = "${var.TF_VAR_subnets_dpl_ru_central1_a_id}"
  token               = "${var.TF_VAR_token}"
  use_ipv4_nat        = true
  zone                = "${var.TF_VAR_tf_www_region}"
  ssh_username        = "${var.TF_VAR_tf_www_user}"
}

build {
  
  sources = ["source.yandex.yc-toolbox"]

  provisioner "file" {
    source = "../../templates/wp-config.php"
    destination = "/tmp/wp-config.php"
  }

  provisioner "shell" {
    inline = [
      "sleep 100",
      "sudo apt-get update -y",
      "sudo apt-get install -y curl nginx certbot python3-certbot-nginx openssh-serverc php-fpm php-mysql",
      "sudo su -",
      "sudo curl -s -O https://wordpress.org/latest.tar.gz",
      "sudo tar xzf latest.tar.gz",
      "sudo mv wordpress/* /var/www/",
      "sudo mv /tmp/wp-config.php /var/www/wp-config.php",
      "sudo rm -rf wordpress",
      "sudo chown -R www-data:www-data /var/www",
      "sudo hostname app.link-tel.ru",
      "sudo systemctl enable nginx.service",
      "curl localhost"


  # provisioner "shell" {
  #   inline = [
  #     # Global Ubuntu things
  #     "sudo apt-get update",
  #     "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
  #     "sudo apt-get install -y unzip python3-pip python3.8-venv",

  #     # Yandex Cloud CLI tool (YC)
  #     "curl -s -O https://storage.yandexcloud.net/yandexcloud-yc/install.sh",
  #     "chmod u+x install.sh",
  #     "sudo ./install.sh -a -i /usr/local/ 2>/dev/null",
  #     "rm -rf install.sh",
  #     "sudo sed -i '$ a source /usr/local/completion.bash.inc' /etc/profile",
  
  #     # Docker
  #     "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-keyring.gpg",
  #     "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker-ce containerd.io",
  #     "sudo usermod -aG docker $USER",
  #     "sudo chmod 666 /var/run/docker.sock",
  #     "sudo useradd -m -s /bin/bash -G docker yc-user",

  #     # Docker Artifacts
  #     "docker pull hello-world",
  #     "docker pull -q amazon/aws-cli",
  #     "docker pull -q golang:${var.GOLANG_VER}",

  #     # Terraform (classic way)
  #     #"curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-keyring.gpg",
  #     #"echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null",
  #     #"sudo apt-get update",
  #     #"sudo apt-get install -y terraform",
  #     #
  #     # Alternative Option
  #     "curl -sL https://hashicorp-releases.yandexcloud.net/terraform/${var.TF_VER}/terraform_${var.TF_VER}_linux_amd64.zip -o terraform.zip",
  #     "unzip terraform.zip",
  #     "sudo install -o root -g root -m 0755 terraform /usr/local/bin/terraform",
  #     "rm -rf terraform terraform.zip",
  #     # Terraform configuration file ?
  #     #"cat <<EOF > ~/.terraformrc \n provider_installation { network_mirror { url = \"https://terraform-mirror.yandexcloud.net/\" include = [\"registry.terraform.io/*/*\"] } direct { exclude = [\"registry.terraform.io/*/*\"] } } \n EOF",

  #     # kubectl
  #     "curl -s -LO https://dl.k8s.io/release/v${var.KCTL_VER}/bin/linux/amd64/kubectl",
  #     "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
  #     "rm -rf kubectl",

  #     # Helm
  #     "curl -sSLO https://get.helm.sh/helm-v${var.HELM_VER}-linux-amd64.tar.gz",
  #     "tar zxf helm-v${var.HELM_VER}-linux-amd64.tar.gz",
  #     "sudo install -o root -g root -m 0755 linux-amd64/helm /usr/local/bin/helm",
  #     "rm -rf helm-v${var.HELM_VER}-linux-amd64.tar.gz",
  #     "rm -rf linux-amd64",
  #     # User can add own repo after login like this:
  #     # helm repo add stable https://charts.helm.sh/stable

  #     ## grpccurl
  #     "curl -sSLO https://github.com/fullstorydev/grpcurl/releases/download/v${var.GRPCURL_VER}/grpcurl_${var.GRPCURL_VER}_linux_x86_64.tar.gz",
  #     "tar zxf grpcurl_${var.GRPCURL_VER}_linux_x86_64.tar.gz",
  #     "sudo install -o root -g root -m 0755 grpcurl /usr/local/bin/grpcurl",
  #     "rm -rf grpcurl_${var.GRPCURL_VER}_linux_x86_64.tar.gz",
  #     "rm -rf grpcurl",

  #     # Pulumi
  #     "curl -sSLO https://get.pulumi.com/releases/sdk/pulumi-v${var.PULUMI_VER}-linux-x64.tar.gz",
  #     "tar zxf pulumi-v${var.PULUMI_VER}-linux-x64.tar.gz",
  #     "sudo cp pulumi/* /usr/local/bin/",
  #     "rm -rf pulumi-v${var.PULUMI_VER}-linux-x64.tar.gz",
  #     "rm -rf pulumi",

  #     # Other packages
  #     "sudo apt-get install -y git jq tree tmux",

  #     # Clean
  #     "rm -rf .sudo_as_admin_successful",

  #     # Test - Check versions for installed components
  #     "echo '=== Tests Start ==='",
  #     "yc version",
  #     "terraform version",
  #     "docker version",
  #     "kubectl version --client=true",
  #     "helm version",
  #     "grpcurl --version",
  #     "git --version",
  #     "jq --version",
  #     "tree --version",
  #     "pulumi version",
  #     "echo '=== Tests End ==='"
    ]
  }
}