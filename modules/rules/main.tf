resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn

  port            = var.rules.listener.port
  protocol        = var.rules.listener.protocol
  certificate_arn = var.rules.listener.certificate_arn
  ssl_policy      = var.rules.listener.ssl_policy
  alpn_policy     = var.rules.listener.alpn_policy

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.rules.listener.default_action.target_group].arn
  }

  tags = merge(
    var.tags,
    var.listeners_tags,
  )
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.rules.actions

  listener_arn = aws_lb_listener.this.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group].arn
  }

  dynamic "condition" {
    for_each = each.value.path_patterns == null ? [] : [0]
    content {
      path_pattern {
        values = each.value.path_patterns
      }
    }
  }

  dynamic "condition" {
    for_each = each.value.hosts == null ? [] : [0]
    content {
      host_header {
        values = each.value.hosts
      }
    }
  }
}

resource "aws_lb_target_group" "this" {
  vpc_id = var.vpc_id

  for_each = var.rules.target_groups

  name             = each.value.name
  name_prefix      = each.value.name_prefix
  port             = each.value.port
  protocol         = each.value.protocol
  protocol_version = each.value.protocol_version
  target_type      = each.value.target_type

  connection_termination             = each.value.connection_termination
  deregistration_delay               = each.value.deregistration_delay
  slow_start                         = each.value.slow_start
  proxy_protocol_v2                  = each.value.proxy_protocol_v2
  lambda_multi_value_headers_enabled = each.value.lambda_multi_value_headers_enabled
  load_balancing_algorithm_type      = each.value.load_balancing_algorithm_type
  preserve_client_ip                 = each.value.preserve_client_ip
  ip_address_type                    = each.value.ip_address_type
  load_balancing_cross_zone_enabled  = each.value.load_balancing_cross_zone_enabled

  dynamic "health_check" {
    for_each = each.value.health_check

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
    for_each = each.value.stickiness

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
    each.value.tags,
    {
      "Name" = each.value.name != null ? each.value.name : each.value.name_prefix
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  target_groups_list = flatten([for k, v in var.rules.target_groups : [for l in v.targets : merge(l, { target_group = k })] if v.targets != null])
  target_groups      = { for i in local.target_groups_list : "${i["target_group"]}-${i["id"]}" => i }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = local.target_groups

  target_group_arn  = aws_lb_target_group.this[each.value.target_group].arn
  target_id         = try(each.value.id, null)
  port              = try(each.value.port, null)
  availability_zone = try(each.value.az, null)
}
