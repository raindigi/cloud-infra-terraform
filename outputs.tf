output "instances" {
  value = [
    for i in aws_instance.my-instance : {
      instance_id = i.id
      private_ip  = i.private_ip
      public_ip   = i.public_ip
    }
  ]
}
