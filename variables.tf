variable "name" {
  description = "The name of the load balancer."
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
}

variable "internal" {
  description = "If true, the load balancer will be internal."
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
  type        = list(string)
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing is enabled."
  default     = true
}

variable "enable_deletion_protection" {
  description = "If true, deletion protection is enabled."
  default     = false
}

variable "enable_http2" {
  description = "If true, HTTP/2 is enabled for the load balancer."
  default     = true
}

variable "enable_tls_version_and_cipher_suite_headers" {
  description = "If true, TLS version and cipher suite headers will be inserted into the request logs."
  default     = false
}

variable "enable_xff_client_port" {
  description = "If true, the X-Forwarded-For and X-Forwarded-Port headers will be inserted into the request logs."
  default     = false
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer."
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "If true, invalid header fields are dropped from HTTP requests."
  default     = false
}

variable "preserve_host_header" {
  description = "If true, the Host header is preserved in the request."
  default     = false
}

variable "enable_waf_fail_open" {
  description = "If true, AWS WAF will fail open."
  default     = false
}

variable "desync_mitigation_mode" {
  description = "The desync mitigation mode of the load balancer."
  default     = "defense"
}

variable "xff_header_processing_mode" {
  description = "The processing mode of the X-Forwarded-For header."
  default     = "none"
}

variable "access_logs" {
  description = "Access logs configuration for the load balancer."
  type        = list(object({
    enabled = bool
    bucket  = string
    prefix  = string
  }))
  default     = []
}

variable "subnet_mapping" {
  description = "Mapping of subnets to IP addresses for the load balancer."
  type        = map(object({
    subnet_id            = string
    allocation_id        = string
    private_ipv4_address = string
    ipv6_address         = string
  }))
  default     = {}
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
  default     = 60
}

variable "load_balancer_update_timeout" {
  description = "The maximum time in seconds that the update action should take."
  default     = 60
}

variable "load_balancer_delete_timeout" {
  description = "The maximum time in seconds that the delete action should take."
  default     = 60
}

variable "rules" {
  description = "A list of rules for the ALB."
  type        = list(object({
    target_groups = list(string)
    listeners     = list(string)
  }))
  default     = []
}
