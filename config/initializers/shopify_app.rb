ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "ac87dfecb9f5aeaf35c0b2018f206523"
  config.secret = "c04369d37a560e38b547249ef15d8e9d"
  config.scope = "read_orders,read_products" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
