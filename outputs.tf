output "elb_dns_name" {
  value = "${aws_elb.myELB.dns_name}"
}