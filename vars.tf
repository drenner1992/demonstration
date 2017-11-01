variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "instance_type" {
  description = "the size of the instance to be used during provisioning"
  default     = "t2.micro"
}

variable "image_id" {
  description = "Ubuntu image ID"
  default     = "ami-785db401"
}

variable "subnets" {
  description = "subnet IDs within my VPC"
  type        = "list"
  default     = ["subnet-0ce1b054", "subnet-77607501", "subnet-8f392deb"]
}

variable "location" {
  default     = "Ireland (eu-west-1)"
}

variable "location2" {
  default     = "Frankfurt (eu-west-2)"
}

variable "Image" {
  default     = "Ubuntu Server 14.04"
}