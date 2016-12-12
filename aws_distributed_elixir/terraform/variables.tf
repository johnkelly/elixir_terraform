variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ssh_key_name" {}
variable "aws_region" {
  default = "us-east-1"
}

variable "amis" {
  type    = "map"
  default = {
    "elixir 1.3.4" = "ami-2e8f8c39"
  }
}

variable "jk_ip" {}
