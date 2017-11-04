variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "instance_type" {
  description = "the size of the instance to be used during provisioning"
  default     = "t2.micro"
}

variable "image_id" {
  description = "AWS AMI"
  default     = "ami-acd005d5"
}

variable "subnets" {
  description = "subnet IDs within my VPC"
  type        = "list"
  default     = ["subnet-0ce1b054", "subnet-77607501", "subnet-8f392deb"]
}

variable "DefaultSG" {
  description = "ID for your default SG in your VPC"
  default = ["sg-eaf61193"]
}