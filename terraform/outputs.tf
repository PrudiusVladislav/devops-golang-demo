output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public.*.id
}

output "ec2_instance_id" {
  value = aws_instance.app.id
}

output "rds_instance_endpoint" {
  value = aws_db_instance.postgres.endpoint
}