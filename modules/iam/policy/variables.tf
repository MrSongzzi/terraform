variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}
variable "jsonPath" {
  type = string
}

variable "tags" { 
  type = map(string)
}