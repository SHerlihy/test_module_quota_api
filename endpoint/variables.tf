variable "api_id" {
  type = string
}

variable "root_resource_id"{
  type = string
}

variable "execution_arn" {
  type = string
}

variable "route_path" {
  description = "Single path segment to add to the API, without a leading slash."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._~-]+$", var.route_path))
    error_message = "route_path must be one API Gateway path segment without '/'."
  }
}

variable "http_method" {
  description = "HTTP method exposed by the route."
  type        = string

  validation {
    condition     = contains(["GET", "POST", "PUT", "PATCH", "DELETE"], var.http_method)
    error_message = "http_method must be GET, POST, PUT, PATCH, or DELETE."
  }
}

variable "lambda_function_name" {
  description = "Name of the Lambda function created for the route."
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the IAM role created for Lambda."
  type        = string
}

variable "tags" {
  type        = map(string)
}
