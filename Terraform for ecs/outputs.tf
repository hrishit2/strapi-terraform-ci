output "cluster_name" {
  value = aws_ecs_cluster.strapi_cluster.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.strapi_task.arn
}

output "service_name" {
  value = aws_ecs_service.strapi_service.name
}
