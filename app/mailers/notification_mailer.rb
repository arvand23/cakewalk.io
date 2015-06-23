class NotificationMailer < ActionMailer::Base
  default from: "play@syruplabs.co"

  def receipt(current_user)
  	@current_user = current_user
  	mail(to: @current_user.email, subject: 'Cakewalk.io Receipt')
  end

  def recordingready(currentuser, current_test_url)
  	@current_user = currentuser
  	@current_test_url = current_test_url
  	mail(to: @current_user.email, subject: '<%= @current_test_url %> User Test Recording is Ready!')
  end
end
