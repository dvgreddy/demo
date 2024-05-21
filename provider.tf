provider "google" {
  project = "integral-league-423415-e2"
  region  = "us-central1"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.29.1"
    }
  }

  required_version = ">= 1.0.0"
}
