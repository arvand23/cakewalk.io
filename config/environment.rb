# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Cakewalkio::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => APP_CONFIG[:sendgrid_username],
  :password       => APP_CONFIG[:sendgrid_password],
  :domain         => 'https://protected-plateau-6103.herokuapp.com',
  :enable_starttls_auto => true
}
 
uri = URI.parse('https://api.screenleap.com/v2/screen-shares') 
req = Net::HTTP::Post.new(
  uri.path, initheader = {
    'accountid' => APP_CONFIG[:screenleap_accountid],
    'authtoken' => APP_CONFIG[:screenleap_authtoken]
  }
)