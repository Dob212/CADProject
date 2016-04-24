require 'singleton'

class NewEventLogger
	include Singleton

	def initialize
		@log = File.open("eventLogger.txt", "a")
	end

	def logInformation(information)
		@log.puts(information)
		@log.flush
	end
end