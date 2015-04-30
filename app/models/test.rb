class Test < ActiveRecord::Base
	belongs_to :user

	#validate url

	def create_cw_url #before i called it permalink, it was generating an error because you cant have the same method name and column name.
    	self.cwurl = Digest::SHA1.hexdigest("#{Time.now} - #{self.id} - #{self.url}")
    	self.save
  	end


end
