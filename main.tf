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
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AmazonECSTaskExecutionRolePolicy policy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an inline policy for ecs:CreateCluster and ecs:ListClusters actions
resource "aws_iam_role_policy" "ecs_custom_policy" {
  name   = "ecsCustomPolicy"
  role   = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:CreateCluster",
          "ecs:ListClusters"
        ],
        Resource = ["*"]
      }
    ]
  })
}
