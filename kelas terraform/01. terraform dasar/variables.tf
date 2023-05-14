variable "compute_zone" {
  type = map(any)
  default = {
    "zone-1" = "asia-southeast2-a",
    "zone-2" = "asia-southeast2-b",
    "zone-3" = "asia-southeast2-c",
  }
}

variable "allow_stop_vm" {
  type    = bool
  default = true
}