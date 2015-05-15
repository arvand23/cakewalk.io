class NotificationMailer < ActionMailer::Base
  default from: "play@syruplabs.com"

  def receipt(current_user)
  	@current_user = current_user
  	mail(to: @current_user.email, subject: 'Cakewalk.io Receipt')
  end
end
