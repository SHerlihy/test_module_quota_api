variable "api_id" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "quota" {
  type = object({
      limit = number
      period = string
  })
}

variable "throttle" {
    type = object({
      burst: number
      rate: number
    })
}

variable "path_to_settings" {
    type = map(object({
      burst_limit = number
      rate_limit = number
  }))
}

variable "tags" {
  type        = map(string)
}

locals {
  paths = toset([for key, value in var.path_to_settings : key])
}
