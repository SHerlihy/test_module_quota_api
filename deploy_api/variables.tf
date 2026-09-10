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

variable "method_settings" {
    type = list(object({
      path = string
      burst_limit = number
      rate_limit = number
  }))
}

variable "tags" {
  type        = map(string)
}
