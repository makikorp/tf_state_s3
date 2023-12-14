#variable "host_os" {
#    type = string
#}

variable main_instance_type {
    type = string
    default = "t2.nano"
}

variable vpc_cidr {
    type = string
    default = "10.0.0.0/16"
}

variable public_cidrs {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable private_cidrs {
    type = list(string)
    default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable access_ip {
    type = string
    default = "0.0.0.0/0"
    #default = "your public ip address"
}

variable main_vol_size {
    type = number
    default = 8
}

variable "main_instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
    type = string
}


