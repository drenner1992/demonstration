provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "all" {}


resource "aws_instance" "webserver" {
  count           = 2
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.ec2.id}"]
  subnet_id       = "${element(var.subnets, count.index)}"

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Radbroke Terraform Demonstration</h1><p>This web server is located in ${var.location}</p><p>This is web server number: ${count.index+1}</p><p>My OS is ${var.Image}" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}

resource "aws_instance" "webserver2" {
  count           = 2
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.ec2.id}"]
  subnet_id       = "${element(var.subnets, count.index)}"

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Radbroke Terraform Demonstration</h1><p>This web server is located in ${var.location2}</p><p>This is web server number: ${count.index+3}</p><p>My OS is ${var.Image}" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}

resource "aws_security_group" "ec2" {
  name = "terraform-ec2"
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "myELB" {
  name               = "LiveDemonstration"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]
  instances          = ["${aws_instance.webserver.*.id}", "${aws_instance.webserver2.*.id}"]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
