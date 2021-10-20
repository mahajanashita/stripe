class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token


  protect_from_forgery except: :webhook

  #def create
  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil


    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, "we_1JmJvuSEIApqwlp0nY8MZyUn"
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts "Signature error"
      p e
      return
    end
    
    # Handle the event
    case event.type
    when 'customer.created'
      customer = event.data.object
      @user.update(stripe_customer_id: customer.id)
      @user = User.find_by(email: customer.email)
      
    when 'checkout.session.completed'
      session = event.data.object
      @user = User.find_by(stripe_customer_id: session.customer)
      @user.update(subscription_status: 'active')
    when 'customer.subscription.updated', 'customer.subscription.deleted'
      subscription = event.data.object
      @user = User.find_by(stripe_customer_id: subscription.customer)
      @user.update(
        subscription_status: subscription.status,
        plan: subscription.item.data[0].price.lookup_key,
        )
    end


    render json: {message: 'success'}
  end
end 