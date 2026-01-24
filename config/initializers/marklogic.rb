# MarkLogic connection configuration

Rails.application.config.marklogic = {
  host: ENV.fetch("MARKLOGIC_HOST", "localhost"),
  port: ENV.fetch("MARKLOGIC_PORT", 8000),
  username: ENV.fetch("MARKLOGIC_USERNAME", "admin"),
  password: ENV.fetch("MARKLOGIC_PASSWORD", "admin")
}

# marklogic-core reads configuration from environment variables
