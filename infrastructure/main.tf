locals {
  location = "westeurope"
}

resource "azurerm_resource_group" "cv" {
  name     = "cv-rg"
  location = local.location
}

resource "azurerm_container_app_environment" "cv" {
  name                = "${azurerm_resource_group.cv.name}-env"
  location            = local.location
  resource_group_name = azurerm_resource_group.cv.name
}

resource "azurerm_container_app" "cv-frontend" {
  name                         = "cv-frontend"
  container_app_environment_id = azurerm_container_app_environment.cv.id
  resource_group_name          = azurerm_resource_group.cv.name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend"
      image  = "ghcr.io/${var.repository_owner}/cv-workshop/frontend:latest"
      cpu    = "0.25"
      memory = "0.5Gi"

      env {
        name  = "BACKEND_URL"
        value = "https://${azurerm_container_app.cv-backend.ingress.0.fqdn}"
      }

      env {
        name  = "BACKEND_API_KEY"
        value = "backend-api-key"
      }
    }

    min_replicas    = 1
    max_replicas    = 1
    revision_suffix = substr(var.revision_suffix, 0, 10)
  }

  secret {
    name  = "backend-api-key"
    value = var.api_key
  }

  ingress {
    target_port      = 3000
    external_enabled = true

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "cv-backend" {
  name                         = "cv-backend"
  container_app_environment_id = azurerm_container_app_environment.cv.id
  resource_group_name          = azurerm_resource_group.cv.name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      image  = "ghcr.io/${var.repository_owner}/cv-workshop/backend:latest"
      cpu    = "0.25"
      memory = "0.5Gi"

      env {
        name  = "AppSettings__FrontendApiKey"
        value = "frontend-api-key"
      }

      env {
        name  = "ConnectionStrings__DefaultConnection"
        value = "connection-string"
      }
    }

    min_replicas    = 1
    max_replicas    = 1
    revision_suffix = substr(var.revision_suffix, 0, 10)
  }

  secret {
    name  = "fontend-api-key"
    value = var.api_key
  }

  secret {
    name  = "connection-string"
    value = var.connection_string
  }

  ingress {
    target_port      = 8080
    external_enabled = true

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

output "frontend_url" {
  value = "https://${azurerm_container_app.cv-frontend.ingress.0.fqdn}"
}

output "backend_url" {
  value = "https://${azurerm_container_app.cv-backend.ingress.0.fqdn}"
}
