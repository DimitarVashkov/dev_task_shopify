module ApplicationHelper
  def get_product_title(id)
    product = ShopifyAPI::Product.find(id)
    product.title
  end
end
