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

	def min_no_of_clicks
		prev_ch = nil
		clicks = 0
		curr_ch = nil
		browse_channels.each do |bc|
			direct_clicks = bc.to_s.length
			up_or_down_clicks = no_of_up_or_down_clicks(curr_ch, bc)
			back_click = no_of_back_clicks(prev_ch, bc)
			clicks += [direct_clicks, up_or_down_clicks, back_click].min
			prev_ch = curr_ch
			curr_ch = bc
		end
		clicks
	end

	def no_of_up_or_down_clicks(curr_ch,next_ch)
		return 999999 if curr_ch.nil?
		abs_diff = (curr_ch - next_ch).abs
		cycle_diff = (min..max).count - abs_diff

		blocked_channels_count_in_range = if curr_ch < next_ch
			blocked_channels.select{|bl| (curr_ch..next_ch).include? bl  }.count
		else
			blocked_channels.select{|bl| (next_ch..curr_ch).include? bl  }.count
		end
		blocked_diff = abs_diff - blocked_channels_count_in_range

		blocked_channels_count_in_range_with_cycle = if curr_ch < next_ch
			blocked_channels.select{|bl| ((@min..curr_ch).include? bl) || ((next_ch..@max).include? bl) }.count
		else
			blocked_channels.select{|bl| ((@min..next_ch).include? bl) || ((curr_ch..@max).include? bl) }.count
		end

		blocked_diff_with_cycle = cycle_diff - blocked_channels_count_in_range_with_cycle

		[abs_diff, cycle_diff, blocked_diff, blocked_diff_with_cycle].min
	end

	def no_of_back_clicks(prev_ch,next_ch)
		if prev_ch == next_ch
			1
		else
			1 + no_of_up_or_down_clicks(prev_ch,next_ch)
		end
	end

	def process
		read_min_max_channels
		read_blocked_channels
		read_browse_channels
		clicks=min_no_of_clicks
		puts "No of clicks required #{clicks}"
		clicks
	end

end