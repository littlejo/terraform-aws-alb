variable "load_balancer_arn" {
  description = "The ARN of the load balancer to attach listeners and target groups to."
  type        = string
}

variable "rules" {
  description = "Rules of the one listener alb"
  type = object({
    listener = object({
      port            = number
      protocol        = string
      certificate_arn = optional(string)
      ssl_policy      = optional(string)
      alpn_policy     = optional(string)
      tags            = optional(map(string))
      default_action = object({
        target_group = string
      })
    })
    actions = map(object({
      priority     = optional(string)
      target_group = string
      hosts        = list(string)
      })
    )
    target_groups = map(
      object({
        name                               = optional(string)
        name_prefix                        = optional(string)
        port                               = number
        protocol                           = string
        protocol_version                   = optional(string)
        target_type                        = string
        connection_termination             = optional(string)
        deregistration_delay               = optional(number)
        slow_start                         = optional(number)
        proxy_protocol_v2                  = optional(bool, false)
        lambda_multi_value_headers_enabled = optional(bool, false)
        load_balancing_algorithm_type      = optional(string)
        preserve_client_ip                 = optional(bool)
        ip_address_type                    = optional(string)
        load_balancing_cross_zone_enabled  = optional(bool)
        health_check = optional(list(
          object({
            enabled             = optional(bool)
            interval            = optional(number)
            path                = optional(string)
            port                = optional(number)
            healthy_threshold   = optional(number)
            unhealthy_threshold = optional(number)
            timeout             = optional(number)
            protocol            = optional(string)
            matcher             = optional(string)
          })
          )
        , [])

        stickiness = optional(list(
          object({
            enabled         = optional(bool)
            cookie_duration = optional(number)
            type            = optional(string)
            cookie_name     = optional(string)
          })
          )
        , [])

        targets = optional(list(
          object({
            port = number
            id   = string
            az   = optional(string)
          })
        ))
        tags = optional(map(string), {})
      })
    )
  })
}

variable "tags" {
  description = "A mapping of tags to assign to the ALB, listeners, and target groups."
  type        = map(string)
  default     = {}
}

variable "listeners_tags" {
  description = "A mapping of tags to assign to listeners specifically."
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
  type        = string
}
