variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-creds.json"
}


variable "region" {
  description = "Region"
  default     = "us-central1"
}


variable "project" {
  description = "Project"
  default     = "project-a8af3f69-6498-47f8-8da"
}


variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My Big Query Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "project-a8af3f69-6498-47f8-8da-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}