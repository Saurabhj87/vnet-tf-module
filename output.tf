
output "VPC" {
  value = aws_vpc.My-VPC-DEV
}
 output "private_subnet_id" {
  value = aws_subnet.private-subnets.*.id
}
output "public_subnet_id" {
  value = aws_subnet.public-subnets.*.id
}
/* output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
} */