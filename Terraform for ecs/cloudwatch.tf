resource "aws_cloudwatch_metric_alarm" "strapi_high_cpu" {
  alarm_name          = "strapi-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm when Strapi CPU exceeds 75%"
  alarm_actions       = [] # Add SNS ARN for notifications if needed
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_metric_alarm" "strapi_high_memory" {
  alarm_name          = "strapi-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm when Strapi Memory usage exceeds 75%"
  alarm_actions       = []
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_metric_alarm" "strapi_network_in" {
  alarm_name          = "strapi-high-network-in"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkBytesIn"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Sum"
  threshold           = 50000000 # 50MB in a minute
  alarm_description   = "Alarm when network IN is high"
  alarm_actions       = []
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_metric_alarm" "strapi_network_out" {
  alarm_name          = "strapi-high-network-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkBytesOut"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Sum"
  threshold           = 50000000 # 50MB in a minute
  alarm_description   = "Alarm when network OUT is high"
  alarm_actions       = []
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}
resource "aws_cloudwatch_dashboard" "strapi_dashboard" {
  dashboard_name = "Strapi-ECS-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title = "Strapi CPU Utilization",
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.strapi_service.name]
          ],
          view   = "timeSeries",
          region = "ap-south-1",
          stat   = "Average",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title = "Strapi Memory Utilization",
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.strapi_service.name]
          ],
          view   = "timeSeries",
          region = "ap-south-1",
          stat   = "Average",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title = "Network In",
          metrics = [
            ["AWS/ECS", "NetworkBytesIn", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.strapi_service.name]
          ],
          view   = "timeSeries",
          region = "ap-south-1",
          stat   = "Sum",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title = "Network Out",
          metrics = [
            ["AWS/ECS", "NetworkBytesOut", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.strapi_service.name]
          ],
          view   = "timeSeries",
          region = "ap-south-1",
          stat   = "Sum",
          period = 60
        }
      }
    ]
  })
}
