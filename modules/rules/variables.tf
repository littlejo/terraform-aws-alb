variable "load_balancer_arn" {
  description = "The ARN of the load balancer to attach listeners and target groups to."
}

variable "listeners" {
  description = "A list of listener configurations for the ALB."
  type        = list(object({
    port            = number
    protocol        = string
    certificate_arn = string
    ssl_policy      = string
    alpn_policy     = string
    tags            = map(string)
  }))
  default     = []
}

variable "target_groups" {
  description = "A list of target group configurations for the ALB."
  type        = map(object({
    name                          = string
    name_prefix                   = string
    port                          = number
    protocol                      = string
    protocol_version              = string
    target_type                   = string
    connection_termination        = string
    deregistration_delay          = number
    slow_start                    = number
    proxy_protocol_v2             = bool
    lambda_multi_value_headers_enabled = bool
    load_balancing_algorithm_type = string
    preserve_client_ip            = bool
    ip_address_type               = string
    load_balancing_cross_zone_enabled = bool
    health_check                  = map(object({
      enabled             = bool
      interval            = number
      path                = string
      port                = number
      healthy_threshold   = number
      unhealthy_threshold = number
      timeout             = number
      protocol            = string
      matcher             = string
    }))
    stickiness                    = map(object({
      enabled         = bool
      cookie_duration = number
      type            = string
      cookie_name     = string
    }))
    tags                          = map(string)
  }))
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the ALB, listeners, and target groups."
  type        = map(string)
  default     = {}
}

variable "https_listeners_tags" {
  description = "A mapping of tags to assign to HTTPS listeners specifically."
  type        = map(string)
  default     = {}
}

variable "target_group_tags" {
  description = "A mapping of tags to assign to target groups specifically."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC in which to create the ALB and target groups."
}

variable "listener_ssl_policy_default" {
  description = "The default SSL policy to use for HTTPS listeners if not specified."
  default     = ""
}
