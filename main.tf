terraform {
  required_version = "~>1.14.3"
}

locals {
  name   = "gha-terraform-poc"
  region = "jp-osa"
}

resource "linode_vpc" "main" {
  label  = local.name
  region = local.region
}

resource "linode_vpc_subnet" "gateway" {
  vpc_id = linode_vpc.main.id
  label  = "${local.name}-gateway"
  ipv4   = "10.0.1.0/24"
}

resource "linode_instance" "gateway" {
  label  = "${local.name}-gateway"
  region = local.region

  # 選択できるサーバータイプは script/fetch-linode-server-type.sh を実行し取得する　
  type = "g6-nanode-1"

  image     = "linode/ubuntu24.04"
  root_pass = var.instance_default_root_pass

  authorized_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKaBsW0ah8wVD8qMmKmlw9yBtoLNVzO88l6StYoA/T1"
  ]

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = linode_vpc_subnet.gateway.id
    ipv4 {
      vpc = "10.0.1.10"
    }
  }

  private_ip = true
}

resource "linode_firewall" "gateway" {
  label = "${local.name}-gateway"

  outbound_policy = "ACCEPT"
  inbound_policy  = "DROP"

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  linodes = [
    linode_instance.gateway.id
  ]
}
