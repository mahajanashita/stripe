class CheckoutController < ApplicationController

	def create
		@session = Stripe::Checkout::Session.create({
             customer: current_user.stripe_customer_id,
             success_url: posts_url,
             cancel_url: pricing_url,
             #added locale for the languaage 
             locale: 'fr',
             payment_method_types: ['card'],
             line_items: [
                {price: params[:price], quantity: 1},
             ],
            mode: 'subscription',
})
		respond_to do |format|
			format.js
		end
	end

end