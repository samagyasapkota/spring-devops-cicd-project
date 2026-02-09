variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID"
  type        = string
  default     = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 in us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "petclinic-key"
}
