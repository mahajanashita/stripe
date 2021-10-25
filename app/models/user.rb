class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def to_s
  	email
  end

  after_create do
     customer = Stripe::Customer.create(email: self.email)
     update(stripe_customer_id: customer.id)  	 #COMMENT THIS FOR WEBHOOKS
  end
  #if self.stripe_customer_id.nil?
              #customer = Stripe::Customer.create(email: self.email)
              #here we are creating a stripe customer with the help of the Stripe library and pass as parameter email. 
              #update(stripe_customer_id: customer.id)
              #we are updating current_user and giving to it stripe_id which is equal to id of customer on Stripe
            #end
end
