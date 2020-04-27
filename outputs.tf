output "instances" {
  value = [
    for i in aws_instance.instances : {
      instance_id = i.id
      private_ip  = i.private_ip
      public_ip   = i.public_ip
    }
  ]
}
