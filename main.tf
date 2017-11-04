provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "all" {}

data "template_file" "user_data_0" {
  template = "${file("${path.module}/user_data_0.tpl")}"
}
data "template_file" "user_data_1" {
  template = "${file("${path.module}/user_data_1.tpl")}"
}
data "template_file" "user_data_2" {
  template = "${file("${path.module}/user_data_2.tpl")}"
}

resource "aws_instance" "webserver" {
  count           = 1
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = "${var.DefaultSG}"
  subnet_id       = "${element(var.subnets, 0)}"
  user_data       = "${data.template_file.user_data_0.rendered}"
}

resource "aws_instance" "webserver2" {
  count           = 1
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = "${var.DefaultSG}"
  subnet_id       = "${element(var.subnets, 1)}"
  user_data       = "${data.template_file.user_data_1.rendered}"
}

resource "aws_instance" "webserver3" {
  count           = 1
  ami             = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = "${var.DefaultSG}"
  subnet_id       = "${element(var.subnets, 2)}"
  user_data       = "${data.template_file.user_data_2.rendered}"
}

resource "aws_elb" "myELB" {
  name               = "LiveDemonstration"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = "${var.DefaultSG}"
  instances          = ["${aws_instance.webserver.*.id}", "${aws_instance.webserver2.*.id}", "${aws_instance.webserver3.*.id}"]
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
    interval            = 30
    target              = "HTTP:80/"
  }
}

