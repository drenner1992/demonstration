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
  default     = "ami-0080e4c5bc078760e"
}

variable "subnets" {
  description = "subnet IDs within my VPC"
  type        = "list"
  default     = ["subnet-24afc943", "subnet-2c9ff202", "subnet-7b08a245"]
}

variable "DefaultSG" {
  description = "ID for your default SG in your VPC"
  default = ["sg-6caf6929"]
}