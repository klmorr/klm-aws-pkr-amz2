variable "ami_name" {
    type = string
    default = "klm-amz2"
}
variable "ami_owners" {
  type    = list(string)
  default = ["amazon"]
}

variable "ami_regions" {
  type = list(string)
  description = "Aws regions to copy the ami to"
  default = ["us-west-1","us-east-1","us-east-2"]
}

variable "builder" {
    type = string
    default = "packer"
}

variable "description" {
  type        = string
  description = "Description for the ami"
  default     = "klm amazon2 linux ami"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}

variable "source_ami" {
  type    = string
  default = "*amzn2-ami-hvm-*"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

data "amazon-ami" "this" {
  filters = {
    architecture                       = "x86_64"
    "block-device-mapping.volume-type" = "gp2"
    name                               = "${var.source_ami}"
    root-device-type                   = "ebs"
    virtualization-type                = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = "${var.region}"
}

source "amazon-ebs" "this" {
  ami_description  = "${var.description}"
  ami_name         = "${var.ami_name}"
  ami_regions      = "${var.ami_regions}"
  force_deregister = true
  instance_type    = "${var.instance_type}"
  region           = "${var.region}"
  source_ami       = "${data.amazon-ami.this.id}"
  ssh_username     = "${var.ssh_username}"
  tags = {
    Name        = "${var.ami_name}"
    builder     = "${var.builder}"
    build_date  = "${formatdate("MM-DD-YYYY", timestamp())}"
    description = "${var.description}"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "shell" {
    script = "./scripts/provisioner.sh"
  }

  post-processor "manifest" {
    output     = "amazon_linux_2_manifest.json"
    strip_path = true
  }
}
