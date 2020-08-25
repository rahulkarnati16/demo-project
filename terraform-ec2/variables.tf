variable "app" {
  type        = "string"
  default     = ""
}

variable "env" {
  type        = "string"
  default     = ""
}

variable "owner" {
  type        = "string"
  default     = ""
}

variable "createdBy" {
  type        = "string"
  default     = ""
}

variable "instance_type" {
  type        = "string"
  default     = ""
}

variable "internal_vpc_id" {
  type        = "string"
  default     = ""
}

variable "CSV_STRING" {
  type        = "string"
  default     = ","
}

variable "internal_vpc_subnet_id" {
  type        = "string"
  default     = ""
}

variable "availability_zone" {
  type        = "string"
  default     = ""
}

variable "server_count" {
  type        = "string"
  default     = ""
}

variable "volume_size" {
  type        = "string"
  default     = ""
}

variable "kms_key_id" {
  type        = "string"
  default     = ""
}

variable "aws_region" {
  type        = "string"
  default     = ""
}

variable "associate_pub_ip" {
  type        = "string"
  default     = ""
}