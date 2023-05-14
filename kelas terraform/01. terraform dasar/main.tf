terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.59.0"
    }
  }
}

provider "google" {
  project = "rahadiangg-belajar-terraform"
  region  = "asia-southeast2"
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

// membuat service account
resource "google_service_account" "my_service_account" {
  account_id   = "mantap-sa"
  display_name = "Mantap SA"
}

//===============
// Membuat VM

resource "google_compute_instance" "test" {
  name                      = "test"
  machine_type              = "e2-medium"
  zone                      = var.compute_zone["zone-1"]
  allow_stopping_for_update = var.allow_stop_vm

  # lifecycle {
  #   prevent_destroy = true
  # }


  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  #   metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.my_service_account.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "test-2" {
  name                      = "test-2"
  machine_type              = "e2-medium"
  zone                      = var.compute_zone["zone-1"]
  allow_stopping_for_update = var.allow_stop_vm


  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  #   metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.my_service_account.email
    scopes = ["cloud-platform"]
  }
}

// import vm
resource "google_compute_instance" "web-server-vm" {
  name         = "web-server-vm"
  machine_type = "f1-micro"
  allow_stopping_for_update = var.allow_stop_vm

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.my_service_account.email
    scopes = ["cloud-platform"]
  }
}