output "template_private" {
  value = aws_launch_template.launch_template_private.id
}
output "template_public" {
  value = aws_launch_template.launch_template_public.id
}