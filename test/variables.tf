variable "profile" {
  type     = string
  default  = null
  nullable = true
}

variable "tags" {
  type        = map(string)
}
