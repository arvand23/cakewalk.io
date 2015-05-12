class Test < ActiveRecord::Base
	belongs_to :user

	#validate url
	validates :url, presence: true

	#sticks http at beggining so that redirects and links on start work
	PROTOCOLS = ["http://", "https://", "ftp://", "ftps://"]
	  validates_format_of :url, :with => URI::regexp(%w(http https ftp ftps))
	  before_validation :ensure_link_protocol

	  def ensure_link_protocol
	    valid_protocols = ["http://", "https://", "ftp://", "ftps://"]
	    return if url.blank?
	    self.url = "http://#{url}" unless PROTOCOLS.any?{|p| url.start_with? p}
	  end

	def create_cw_url #before i called it permalink, it was generating an error because you cant have the same method name and column name.
    	self.cwurl = Digest::SHA1.hexdigest("#{Time.now} - #{self.id} - #{self.url}")
    	self.save
  	end


end
