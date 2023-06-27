terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

// Earlier versions of Terraform used empty provider blocks ("proxy provider configurations") for child modules to declare their
// need to be passed a provider configuration by their callers. That approach was ambiguous and is now deprecated.

# provider "local" {  
# }