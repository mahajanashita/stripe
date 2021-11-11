class BillingPortalController < ApplicationController

	def create 

		portal_session = Stripe::BillingPortal::Session.create({
          customer: current_user.stripe_customer_id,
          return_url: root_url ,
          #added locale here 
          locale: 'auto'
         })
        redirect_to portal_session.url
    end
end