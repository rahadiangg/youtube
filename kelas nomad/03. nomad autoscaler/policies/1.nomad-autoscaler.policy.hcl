namespace "default" {
  policy = "scale"

  // for HA nomad autoscaler
  variables {
    path "nomad-autoscaler/lock" {
      capabilities = ["write"]
    }
  }
}

// for Horizontal Cluster Autoscaling
node {
  policy = "write"
}