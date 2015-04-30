class StaticController < ApplicationController
  def home
  	@url = Test.new
  	if current_user
  		@userurls= current_user.tests.all(:order => 'created_at DESC')
  	end
  end
end
