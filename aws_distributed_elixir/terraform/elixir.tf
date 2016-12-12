resource "aws_security_group" "elixir_ec2" {
  name        = "elixir EC2"
  description = "Security Group for elixir instances"
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["${var.jk_ip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.meetup.id}"
}

resource "aws_security_group" "elixir_epmd" {
  name        = "elixir EC2 epmd"
  description = "Security Group for distributed"
  ingress {
    from_port       = 9100
    to_port         = 9155
    protocol        = "tcp"
    cidr_blocks     = ["${var.jk_ip}"]
    security_groups = ["${aws_security_group.elixir_ec2.id}"]
  }
  ingress {
    from_port       = 4369
    to_port         = 4369
    protocol        = "tcp"
    cidr_blocks     = ["${var.jk_ip}"]
    security_groups = ["${aws_security_group.elixir_ec2.id}"]
  }
  vpc_id = "${aws_vpc.meetup.id}"
}

resource "aws_launch_configuration" "elixir_demand_launch_config" {
  associate_public_ip_address = true
  name_prefix                 = "elixir_demand_launch_config_"
  image_id                    = "${lookup(var.amis, "elixir 1.3.4")}"
  instance_type               = "t2.small"
  key_name                    = "${var.aws_ssh_key_name}"
  security_groups             = ["${aws_security_group.elixir_ec2.id}","${aws_security_group.elixir_epmd.id}"]
  user_data                   = "${file("userdata.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "elixir_demand_asg" {
  desired_capacity     = 0
  launch_configuration = "${aws_launch_configuration.elixir_demand_launch_config.name}"
  name                 = "elixir_demand_asg"
  max_size             = 2
  min_size             = 0
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-public.id}", "${aws_subnet.us-east-1b-public.id}", "${aws_subnet.us-east-1d-public.id}", "${aws_subnet.us-east-1e-public.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "elixir_spot_launch_config" {
  associate_public_ip_address = true
  name_prefix                 = "elixir_spot_launch_config_"
  image_id                    = "${lookup(var.amis, "elixir 1.3.4")}"
  instance_type               = "m3.medium"
  key_name                    = "${var.aws_ssh_key_name}"
  security_groups             = ["${aws_security_group.elixir_ec2.id}","${aws_security_group.elixir_epmd.id}"]
  spot_price                  = "0.10"
  user_data                   = "${file("userdata.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "elixir_spot_asg" {
  desired_capacity     = 0
  launch_configuration = "${aws_launch_configuration.elixir_spot_launch_config.name}"
  name                 = "elixir_spot_asg"
  max_size             = 1
  min_size             = 0
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-public.id}", "${aws_subnet.us-east-1b-public.id}", "${aws_subnet.us-east-1d-public.id}", "${aws_subnet.us-east-1e-public.id}"]

  lifecycle {
    create_before_destroy = true
  }
}
