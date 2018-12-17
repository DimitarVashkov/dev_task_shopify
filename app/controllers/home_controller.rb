class HomeController < ShopifyApp::AuthenticatedController
  CYCLE = 0.5 # add cycle time
   helper_method :get_product_title

  def index
    @date = DateTime.now.to_date

    if params[:date]
      @date = params[:date].to_date
    end

    @order_count = ShopifyAPI::Order.count(params: {
      processed_at_min: @date,
      processed_at_max: @date+1,
      status: "any"
      })
    @nb_pages = (@order_count / 250.0).ceil

    @topItems = calculate_top_3_items_from(@nb_pages)
  end

  private
  def calculate_top_3_items_from(nb_pages)
    summary = Hash.new(0)

    # Start timer
    start_time = Time.now

    1.upto(nb_pages) do |page|

      # Add basic timer functionality - shopify help section used for reference
      unless page == 1
        stop_time = Time.now
        puts "Last batch processing started at #{start_time.strftime('%I:%M%p')}"
        puts "The time is now #{stop_time.strftime('%I:%M%p')}"
        processing_duration = stop_time - start_time
        puts "The processing lasted #{processing_duration.to_i} seconds."
        wait_time = (CYCLE - processing_duration).ceil
        puts "We have to wait #{wait_time} seconds then we will resume."
        sleep wait_time if wait_time > 0
        start_time = Time.now
      end

      orders = ShopifyAPI::Order.find(:all,params: {
        processed_at_min: @date,
        processed_at_max: @date+1,
        status: "any",
        limit: 250,
        page: page
        })

      orders.each do |order|
        order.line_items.each do |item|
          summary[item.product_id] += item.quantity
        end
      end

    end

    # summary.transform_keys! {|k| get_product_title(k)}

    # Sort line items by quantity and get the top 3
    summary.sort_by { |_, quantity| -quantity }.first(3)
  end


  # Define a helper method that finds product title from id
  def get_product_title(id)
    product = ShopifyAPI::Product.find(id)
    product.title
  end


end
