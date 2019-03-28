provider "aws" {
  region = "us-east-1"
  access_key = "xxx"
  secret_key = "xxx"
}

data "aws_availability_zones" "all" {}

data "template_file" "user_data_0" {
  template = "${file("${path.module}/user_data_0.tpl")}"
}

resource "aws_instance" "webserver" {
  count           = 3
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = "${var.DefaultSG}"
  subnet_id       = "${element(var.subnets, count.index)}"
  user_data       = "${data.template_file.user_data_0.rendered}"
}

resource "aws_elb" "myELB" {
  name               = "LiveDemonstration"
  availability_zones = ["us-east-1a", "us-east-1b","us-east-1c", "us-east-1d","us-east-1e","us-east-1f"]
  security_groups    = "${var.DefaultSG}"
  instances          = ["${aws_instance.webserver.*.id}"]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
    target              = "HTTP:80/"
  }
}

