namespace "default" {
  variables {
    path "secret/aws/*" {
      capabilities = [
        "read",
        "list"
      ]
    }
  }
}