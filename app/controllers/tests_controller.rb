class TestsController < ApplicationController
	def create
		@url = Test.new(url_params)
		@url.user_id = current_user.id
		@url.create_cw_url

		if @url.save
			redirect_to static_home_path, :notice => "Success"
		else
			render static_home_path, :alert => "Fail"
		end
	end

	def start #/tests/3240234/start
		@test = Test.find_by_cwurl(params[:id])
	end

	def upgrade
		@current_user = current_user
	end

	def charge
		raise ActiveRecord::RecordNotFound unless [1,5].include?(params[:plan].to_i) #does this array include these numbers.. did dude try to hack
		# Amount in cents
		  @amount = params[:plan].to_i == 1 ? 2500 : 10000 

		  customer = Stripe::Customer.create(
		    :email => current_user.email,
		    :card  => params[:stripeToken]
		  )

		  charge = Stripe::Charge.create(
		    :customer    => customer.id,
		    :amount      => @amount,
		    :description => "#{params[:plan]} Cakewalk.io User Test",     
		    :currency    => 'usd'
		  )

		  @current_user = current_user
		  @current_user.balance += params[:plan].to_i
		  @current_user.save
		  redirect_to static_home_path, :notice => "You just bought #{params[:plan]} credit." 

		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to root_path, :notice => "Stripe err"
	end


	private
		def url_params
			params.require(:test).permit(:url)
		end
end
