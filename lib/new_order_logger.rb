require 'singleton'

class NewOrderLogger
	include Singleton

	def initialize
		@log = File.open("Orders_Logger.txt", "a")
	end

	def logInformation(information)
		@log.puts(information)
		@log.flush
	end
end