variable "subnet_cidr" {
  default = ["10.33.1.0/24", "10.33.2.0/24", "10.33.3.0/24"]
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {
  default = "adminsree"
}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "subscription_id" {}

