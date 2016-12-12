provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_vpc" "meetup" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.meetup.id}"
}

resource "aws_subnet" "us-east-1a-public" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.0.0/24"
  vpc_id            = "${aws_vpc.meetup.id}"
}

resource "aws_subnet" "us-east-1b-public" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.1.0/24"
  vpc_id            = "${aws_vpc.meetup.id}"
}

resource "aws_subnet" "us-east-1d-public" {
  availability_zone = "us-east-1d"
  cidr_block        = "10.0.2.0/24"
  vpc_id            = "${aws_vpc.meetup.id}"
}

resource "aws_subnet" "us-east-1e-public" {
  availability_zone = "us-east-1e"
  cidr_block        = "10.0.3.0/24"
  vpc_id            = "${aws_vpc.meetup.id}"
}

resource "aws_route_table" "us-east-1-public" {
  vpc_id = "${aws_vpc.meetup.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "us-east-1a-public" {
  subnet_id      = "${aws_subnet.us-east-1a-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_route_table_association" "us-east-1b-public" {
  subnet_id      = "${aws_subnet.us-east-1b-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_route_table_association" "us-east-1d-public" {
  subnet_id      = "${aws_subnet.us-east-1d-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_route_table_association" "us-east-1e-public" {
  subnet_id      = "${aws_subnet.us-east-1e-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}
