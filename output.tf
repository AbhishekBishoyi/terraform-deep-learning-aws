output "conn" {
  value = "ssh -i \"${aws_key_pair.generated_key.key_name}\" ec2-user@${aws_instance.deepLearning.public_dns}"
}