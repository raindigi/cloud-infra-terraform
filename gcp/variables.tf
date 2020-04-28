variable "project" {
  type        = string
  description = "GCP project ID in which to create the resources (list projects with 'gcloud projects list')."
}

variable "localhost_ip" {
  type        = string
  description = "Public IP address of the local machine (this IP address will get SSH access to the instances)."
}

variable "service_account_key_file" {
  type        = string
  description = "Service account key file of the GCP service account that Terraform will use to access GCP."
  default     = "key.json"
}

variable "region" {
  type        = string
  description = "GCP region in which to create regional resources (list regions with 'gcloud compute regions list')."
  default     = "europe-west6"
}

variable "zone" {
  type        = string
  description = "GCP zone in which to create zonal resources (list zones with 'gcloud compute zones list')."
  default     = "europe-west6-a"
}

variable "name" {
  type        = string
  description = "Common name for the created GCP resources."
  default     = "example-infra-terraform"
}
