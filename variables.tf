variable "name" {
  description = "The name of the load balancer."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  type        = string
  default     = null
}

variable "internal" {
  description = "If true, the load balancer will be internal."
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the load balancer."
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the load balancer."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing is enabled."
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "If true, deletion protection is enabled."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "If true, HTTP/2 is enabled for the load balancer."
  type        = bool
  default     = true
}

variable "enable_tls_version_and_cipher_suite_headers" {
  description = "If true, TLS version and cipher suite headers will be inserted into the request logs."
  type        = bool
  default     = false
}

variable "enable_xff_client_port" {
  description = "If true, the X-Forwarded-For and X-Forwarded-Port headers will be inserted into the request logs."
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer."
  type        = string
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "If true, invalid header fields are dropped from HTTP requests."
  type        = bool
  default     = false
}

variable "preserve_host_header" {
  description = "If true, the Host header is preserved in the request."
  type        = bool
  default     = false
}

variable "enable_waf_fail_open" {
  description = "If true, AWS WAF will fail open."
  type        = bool
  default     = false
}

variable "desync_mitigation_mode" {
  description = "The desync mitigation mode of the load balancer."
  type        = string
  default     = "defensive"
}

variable "xff_header_processing_mode" {
  description = "The processing mode of the X-Forwarded-For header."
  type        = string
  default     = "append"
}

variable "access_logs" {
  description = "Access logs configuration for the load balancer."
  type = list(object({
    enabled = bool
    bucket  = string
    prefix  = string
  }))
  default = []
}

variable "subnet_mapping" {
  description = "Mapping of subnets to IP addresses for the load balancer."
  type = map(object({
    subnet_id            = string
    allocation_id        = string
    private_ipv4_address = string
    ipv6_address         = string
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the load balancer."
  type        = map(string)
  default     = {}
}

variable "lb_tags" {
  description = "A mapping of tags to assign to the load balancer."
  type        = map(string)
  default     = {}
}

variable "load_balancer_create_timeout" {
  description = "The maximum time in seconds that the create action should take."
  type        = string
  default     = "10m"
}

variable "load_balancer_update_timeout" {
  description = "The maximum time in seconds that the update action should take."
  type        = string
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  description = "The maximum time in seconds that the delete action should take."
  type        = string
  default     = "10m"
}

variable "rules" {
  description = "rules of one ALB listener"
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
