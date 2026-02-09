environment = "nonprod"
name_prefix = "nti-final"

desired_size = 2
min_size     = 1
max_size     = 3

# IRSA Configuration
create_app_irsa     = true
app_namespace       = "nti-app"
app_service_account = "nti-app-sa"

# API Gateway (disabled by default - enable when you have an ingress LB)
enable_api_gateway = false
