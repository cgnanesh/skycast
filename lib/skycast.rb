class Skycast
	attr_accessor :min , :max, :blocked_channels_count, :blocked_channels, :browse_channels_count, :browse_channels

	def read_min_max_channels
		min_max = read_input_from_console("Enter min and max value for channels separated by spaces")
		if min_max.count != 2
			raise "wrong no values for min and max channels"
		elsif min_max.find{|x| x==0 || x > 10000}
			raise "Min or max channel cannot be zero or greater than 10,000"
		elsif min_max[0] > min_max[1]
			raise "Min cannot be greater than max channel"
		end

		@min, @max = min_max
	end

	def read_blocked_channels
		@blocked_channels = read_input_from_console("Enter blocked channels")
		@blocked_channels_count = blocked_channels.shift
		@blocked_channels = @blocked_channels.uniq
		if bad_channel = @blocked_channels.find{|x| !((min..max).include? x) }
			raise "Blocked channel #{bad_channel} is not valid channel"
		elsif @blocked_channels.count > 40
			raise "Blocked channels cannot be more thean 40"
		end
	end

	def read_browse_channels
		@browse_channels=read_input_from_console("Enter browse channels")
		@browse_channels_count = browse_channels.shift
		if bad_channel = @browse_channels.find{|x| !((min..max).include? x) }
			raise "Browse channel #{bad_channel} is not valid channel"
		elsif !((1..50).include? @browse_channels.count)
			raise "Browse channels count should be atleast be 1 and less than 50"
		elsif blocked_channel = @browse_channels.find{|x| (blocked_channels.include? x) }	
			raise "Browse channel #{blocked_channel} is blocked channel"
		end
	end

	def read_input_from_console(msg)
		puts(msg)
		gets.chomp.split.map(&:to_i)
	end
end