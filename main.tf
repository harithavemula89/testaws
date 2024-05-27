provider "aws" {
  region = "us-east-1" # Update to your desired region
}

# Define a variable for the cluster name
variable "cluster_name" {
  description = "The name of the ECS Cluster"
  default     = "my-ecs-cluster1"
}

# Create the ECS Cluster
resource "aws_ecs_cluster" "my_cluster1" {
  name = var.cluster_name
}

# Create an IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Action": [
                "ecs:CreateCluster",
                "ecs:ListClusters",
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
