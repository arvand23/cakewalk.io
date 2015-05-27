class ScreenShare < ActiveRecord::Base
  has_many :screen_share_events
  belongs_to :test
end
