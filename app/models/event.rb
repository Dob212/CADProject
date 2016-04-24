class Event < ActiveRecord::Base
	def self.search(search)
		where("ename LIKE ?", "%#{search}%")
	end
end
