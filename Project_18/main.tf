# A resource that needs no cloud credentials, so the pipeline can really apply it
resource "terraform_data" "demo" {
  input = var.message
}
