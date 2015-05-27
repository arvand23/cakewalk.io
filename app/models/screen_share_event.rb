class ScreenShareEvent < ActiveRecord::Base
  belongs_to :screen_share
  has_many :screen_share_files # has_one?
end
