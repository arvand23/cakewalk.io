class StaticController < ApplicationController
  def home
  	@url = Test.new
  	@userurls= current_user.tests.all(:order => 'created_at DESC')
  end
end
