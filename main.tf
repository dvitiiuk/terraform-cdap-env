terraform {
  required_providers {
    google-beta = {
      source = "some.host/hashicorp/google-beta"
      //version = "4.31.0"
      version = "15.0.0"
    }
    cdap = {
      source = "some.host/dvitiuk/cdap"
      //source = "GoogleCloudPlatform/cdap"
      version = "1.0.0"
      //version = "0.10.0"
    }
  }
}

data "google_client_config" "current_client" {
  provider = google-beta
}

provider "google-beta" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

provider "cdap" {
  host  = "${google_data_fusion_instance.basic_instance.service_endpoint}/api"
  token = data.google_client_config.current_client.access_token
}

resource "google_data_fusion_instance" "basic_instance" {
  provider    = google-beta
  name        = "my-instance"
  region      = "us-central1"
  type        = "BASIC"
  enable_rbac = false
  version     = "6.6.0"
}

resource "cdap_namespace" "user0_ns" {
  provider                 = cdap
  name                     = "user0_ns"
  tolerate_to_delete_error = true
}
