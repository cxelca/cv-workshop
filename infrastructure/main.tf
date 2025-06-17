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
  name                         = "cv-frontend-${substr(var.revision_suffix, 0, 8)}" # Using a short SHA for the name
  container_app_environment_id = azurerm_container_app_environment.cv.id
  resource_group_name          = azurerm_resource_group.cv.name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend"
      image  = "ghcr.io/${var.repository_owner}/${var.github_repository_name}/frontend:${var.revision_suffix}"
      cpu    = "0.25"
      memory = "0.5Gi"

      env {
        name  = "BACKEND_URL"
        value = "https://${azurerm_container_app.cv-backend.ingress.0.fqdn}"
      }

      env {
        name  = "BACKEND_API_KEY"
        value = "backend-api-key" # This references the secret name, not its value directly
      }
    }

    min_replicas    = 1
    max_replicas    = 1
    # You already have revision_suffix here, which is good for revisions,
    # but the image tag is crucial for *which* image the revision uses.
    revision_suffix = substr(var.revision_suffix, 0, 10)
  }

  secret {
    # Ensure this name matches the 'env.value' above if you want to use the secret.
    # The `env` block's `value` refers to the `secret.name`, not `secret.value`.
    name  = "backend-api-key"
    value = var.api_key # This is the actual secret value passed from GH Actions
  }

  ingress {
    target_port      = 3000 # Double-check if your frontend container serves on port 3000.
                           # If it's a production build served by Nginx or similar, it's often 80.
                           # If it's a simple dev server (e.g., Vite/Webpack) it might be 3000.
    external_enabled = true

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "cv-backend" {
  # Adding revision_suffix to name for better unique naming across deployments.
  name                         = "cv-backend-${substr(var.revision_suffix, 0, 8)}"
  container_app_environment_id = azurerm_container_app_environment.cv.id
  resource_group_name          = azurerm_resource_group.cv.name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      # --- CHANGE 2: Use var.github_repository_name and var.revision_suffix for image tag ---
      image  = "ghcr.io/${var.repository_owner}/${var.github_repository_name}/backend:${var.revision_suffix}"
      cpu    = "0.25"
      memory = "0.5Gi"

      env {
        name  = "AppSettings__FrontendApiKey"
        value = "frontend-api-key" # References the secret name
      }

      env {
        name  = "ConnectionStrings__DefaultConnection"
        value = "connection-string" # References the secret name
      }
    }

    min_replicas    = 1
    max_replicas    = 1
    revision_suffix = substr(var.revision_suffix, 0, 10)
  }

  secret {
    # --- CHANGE 3: Corrected typo from 'fontend-api-key' to 'frontend-api-key' ---
    name  = "frontend-api-key"
    value = var.api_key # Assuming 'var.api_key' is used for both frontend and backend for simplicity here
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