resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn

  for_each = var.listeners

  port            = each.value.port
  protocol        = each.value.protocol #HTTPS
  certificate_arn = each.value.certificate_arn
  ssl_policy      = each.value.ssl_policy  #lookup(var.https_listeners[count.index], "ssl_policy", var.listener_ssl_policy_default)
  alpn_policy     = each.value.alpn_policy #lookup(var.https_listeners[count.index], "alpn_policy", null)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this["default"].arn
  }

  tags = merge(
    var.tags,
    var.https_listeners_tags,
    each.value.tags,
  )
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.target_groups

  listener_arn = aws_lb_listener.this["default"].arn
  priority     = each.value.rules.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    host_header {
      values = each.value.rules.hosts
    }
  }
}

resource "aws_lb_target_group" "this" {
  vpc_id = var.vpc_id

  for_each = var.target_groups

  name             = each.value.name
  name_prefix      = each.value.name_prefix
  port             = each.value.port
  protocol         = each.value.protocol
  protocol_version = each.value.protocol_version
  target_type      = each.value.target_type

  connection_termination             = each.value.connection_termination
  deregistration_delay               = each.value.deregistration_delay
  slow_start                         = each.value.slow_start
  proxy_protocol_v2                  = each.value.proxy_protocol_v2                  #false
  lambda_multi_value_headers_enabled = each.value.lambda_multi_value_headers_enabled #false
  load_balancing_algorithm_type      = each.value.load_balancing_algorithm_type
  preserve_client_ip                 = each.value.preserve_client_ip
  ip_address_type                    = each.value.ip_address_type
  load_balancing_cross_zone_enabled  = each.value.load_balancing_cross_zone_enabled

  dynamic "health_check" {
    for_each = each.value.health_check #[]

    content {
      enabled             = try(health_check.value.enabled, null)
      interval            = try(health_check.value.interval, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout             = try(health_check.value.timeout, null)
      protocol            = try(health_check.value.protocol, null)
      matcher             = try(health_check.value.matcher, null)
    }
  }

  dynamic "stickiness" {
    for_each = each.value.stickiness #[]

    content {
      enabled         = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type            = try(stickiness.value.type, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
    }
  }

  tags = merge(
    var.tags,
    var.target_group_tags,
    each.value.tags, #{}
    {
      "Name" = try(each.value.name, each.value.name_prefix, "")
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}
