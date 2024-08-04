namespace "default" {
  policy = "read" // allow read all object in this namespace

  // and allow this capability
  capabilities = [
    "submit-job"
  ]
}