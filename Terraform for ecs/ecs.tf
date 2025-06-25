resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/ecs/strapi-logs"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi",
      image     = "gojo922/strapi-app:dev",
      essential = true,
      portMappings = [
        {
          containerPort = 1337,
          hostPort      = 1337,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/strapi-logs",
          awslogs-region        = "ap-south-1",
          awslogs-stream-prefix = "strapi"
        }
      },
      environment = [
        {
          name  = "HOST"
          value = "0.0.0.0"
        },
        {
          name  = "PORT"
          value = "1337"
        },
        {
          name  = "APP_KEYS"
          value = "VYc6Pm8TAmgDqHyYVpZPkg==,e7EPfbVUGglcOROhY895Bw==,7UbGSC1vB4A8YgzVbl8vVw==,2/5apScjuSwd7Co0AtbTDg=="
        },
        {
          name  = "API_TOKEN_SALT"
          value = "UUhnPv6dCxAOapJqtFocjA=="
        },
        {
          name  = "ADMIN_JWT_SECRET"
          value = "kCmMDIY2yiuOlJnHPzddYQ=="
        },
        {
          name  = "TRANSFER_TOKEN_SALT"
          value = "6x3iyku3iyeBlFF0bdmHvA=="
        },
        {
          name  = "ENCRYPTION_KEY"
          value = "sC3UIKNEJMdKLf/vUBD60Q=="
        },
        {
          name  = "JWT_SECRET"
          value = "T7N4Vh5JR4x5Y/+O9JA4Ew=="
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_attach
  ]
}
