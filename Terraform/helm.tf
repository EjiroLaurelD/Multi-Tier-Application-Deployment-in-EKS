# Install Helm
resource "null_resource" "install_helm" {
  provisioner "local-exec" {
    command = "curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash"
  }
}

Deploy the database tier using Helm
resource "helm_release" "database" {
  name      = "database"
  repository = "https://charts.bitnami.com/bitnami"
  chart     = "postgresql"
  version   = "~>10.7.5"

  values = [
    # Customize the database values as per your requirements
    <<EOF
    postgresqlUsername: admin
    postgresqlPassword: mypassword
    persistence:
      enabled: true
      storageClass: "gp2"
      size: "10Gi"
    EOF
  ]
}

# Deploy the backend tier using Helm
resource "helm_release" "backend" {
  name      = "backend"
  repository = "https://charts.example.com"
  chart     = "backend"
  version   = "~>1.0.0"

  values = [
    # Customize the backend values as per your requirements
    <<EOF
    databaseHost: ${helm_release.database.metadata.0.name}
    databaseUsername: admin
    databasePassword: mypassword
    EOF
  ]
}

# Deploy the frontend tier using Helm
resource "helm_release" "frontend" {
  name      = "frontend"
  repository = "https://charts.example.com"
  chart     = "frontend"
  version   = "~>1.0.0"

  values = [
    # Customize the frontend values as per your requirements
    <<EOF
    backendHost: ${helm_release.backend.metadata.0.name}
    EOF
  ]
}
