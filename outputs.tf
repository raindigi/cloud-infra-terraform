output "instances" {
  value = [
    for i in aws_instance.my-instance : {
      instance_id = i.id
      public_ip   = i.public_ip
    }
  ]
}
