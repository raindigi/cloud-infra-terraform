output "instances" {
  value = [
    for i in google_compute_instance.instances : {
      name       = i.name
      private_ip = i.network_interface.0.network_ip
      public_ip  = i.network_interface.0.access_config.0.nat_ip
    }
  ]
}
