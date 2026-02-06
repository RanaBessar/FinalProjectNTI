resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.name_prefix}-${var.environment}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-ecr"
  })
}
