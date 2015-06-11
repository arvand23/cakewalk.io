class TestsController < ApplicationController
	def create
		@url = Test.new(url_params)
		@url.user_id = current_user.id
		@url.create_cw_url

		if @url.save
			redirect_to static_home_path, :notice => "Excellent! Now, share your Cakewalk link with testers."
		else
			@userurls= current_user.tests.all(:order => 'created_at DESC') #needed to add this for validation to work. before everytime validation failed i got undefined method `each' for nil:NilClass validation
			render static_home_path, :alert => "Something went wrong. Try again?"
		end
	end

	def start #/tests/3240234/start
		@test = Test.find_by_cwurl(params[:id])

		require 'json'
		require 'net/http'
		require 'uri'

		uri = URI.parse('https://api.screenleap.com/v2/screen-shares')

		req = Net::HTTP::Post.new(uri.path, initheader = {'accountid' => 'arvando', 'authtoken' => 'DAwrqQpPWR'})
		req.set_form_data({
			enableViewerCam: true,
			useCustomProtocol: true,
			presenterCountryCode: "US",
			minImageQuality: 80, maxImageQuality: 90,
			recordVideo: true,
			autoRecord: true
		})

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		res = http.request(req)

		@screen_share_data = JSON.parse(res.body)

		# we need to store screenShareCode to track a recordering.
		#
		if ScreenShare.create(
		  test: @test,
			# screen_share_code: @screen_share_data['screenShareCode'],
			recording_id: @screen_share_data['recordingId']
		)

		@currentuser = @test.user
        @currentuser.balance = @currentuser.balance - 1
        @currentuser.save

    	else
    		render text: "Error"
    	end 

	end

	def upgrade
		@current_user = current_user
	end

	def decrementbalance

		@currenttest = Test.find_by_cwurl(params[:id])
  		@currenttest.user.balance = 999 #@test.user.balance - 1
  		@currenttest.user.save

  		#respond_to do |format|
  		#	format.json { render json: { success: true} }
  		#end
  	end

	def charge
		@current_user = current_user
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
		  NotificationMailer.receipt(@current_user).deliver

		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to root_path, :notice => "Stripe err"
	end

	def results
		@files = ScreenShareFile.joins(:screen_share_event => :screen_share).where('screen_shares.test_id = ?', params[:id])
		@filesordered = @files.all(:order => 'created_at DESC')
		@currentfile = Test.find(params[:id])
		if @currentfile.created_at.present? 
			@downloadby = @currentfile.created_at+7.day
		else
			@downloadby = "it expires (we're in beta after all)."
		end

	end

	private
		def url_params
			params.require(:test).permit(:url)
		end
end
