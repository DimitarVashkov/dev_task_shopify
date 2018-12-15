class HomeController < ShopifyApp::AuthenticatedController
  def index

    @webhooks = ShopifyAPI::Webhook.find(:all)

    @date = DateTime.now.to_date

    if params[:date]
      @date = params[:date].to_date
    end

    @orders = ShopifyAPI::Order.find(:all,params: {
      processed_at_min: @date,
      processed_at_max: @date+1,
      status: "any",
      limit: 50,
      })

    @topItems = calculate_top_3_items_from(@orders)
  end

  private
  def calculate_top_3_items_from(orders)
    summary = Hash.new(0)

    orders.each do |order|
      order.line_items.each do |item|
        summary[item.title] += item.quantity
      end
    end

    summary.sort_by { |_, v| -v }.first(3)
  end


end
