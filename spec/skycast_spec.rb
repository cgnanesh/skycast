require 'skycast'

describe 'SkycastInput' do
	before :each do 
		@s=Skycast.new
		@s.min = 103
		@s.max = 200
		@s.blocked_channels = []
		@s.blocked_channels_count = 0
		@s.browse_channels = [105 , 106, 107, 103, 105]
		@s.browse_channels_count = 5
	end

	context "with out considering blocked channels" do
		context "with out considering cycle" do
			it "no of up down clicks should be difference" do 
				expect(@s.no_of_up_or_down_clicks(105,106)).to eq(1)
				expect(@s.no_of_up_or_down_clicks(106,105)).to eq(1)
				expect(@s.no_of_up_or_down_clicks(105,107)).to eq(2)
				expect(@s.no_of_up_or_down_clicks(105,111)).to eq(6)
				expect(@s.no_of_up_or_down_clicks(130,125)).to eq(5)
			end
		end

		context "with considering cycle data" do
			it "no of up down clicks should be min of difference between channels or cyclic difference" do 
				@s.max = 110
				expect(@s.no_of_up_or_down_clicks(104,107)).to eq(3)
				expect(@s.no_of_up_or_down_clicks(103,109)).to eq(2)
			end
		end
	end

	context "with considering blocked channels" do 
		context "with out considering cycle" do
			it "no of up down clicks should be difference between channels and should consider blocked channels" do
				@s.max=115
				@s.blocked_channels = [104, 107 , 110]
				@s.blocked_channels_count = 3
				expect(@s.no_of_up_or_down_clicks(105,111)).to be < 6
				expect(@s.no_of_up_or_down_clicks(105,111)).to eq(4)
			end
		end

		context "with considering cycle" do 
			it "no of up down clicks should be min of difference between channels or cyclic difference" do 
				@s.max=115
				@s.blocked_channels = [104, 106, 105, 107, 108, 109, 110]
				@s.blocked_channels_count = 3
				expect(@s.no_of_up_or_down_clicks(111,115)).to be < 4
				expect(@s.no_of_up_or_down_clicks(111,115)).to eq(2)
			end
		end
	end

	it "no of clicks going through back button should be one if previous channel is same as next channel" do 
		expect(@s.no_of_back_clicks(111,111)).to eq(1)
	end

	it "no of clicks should consider going to back and then doing up and down" do 
		expect(@s.no_of_back_clicks(111,110)).to eq(2)
	end

	it "for first channel it is always no of charectors in channel" do
		@s.browse_channels = [104]
		expect(@s.min_no_of_clicks).to eq(3)
		@s.max=5000
		@s.browse_channels = [2000]
		expect(@s.min_no_of_clicks).to eq(4)
	end

	it "minimum no of clicks should return sum of min of up or down clicks , back clicks and direct clicks for each channel" do
		@s.min = 1
		@s.max = 20
		@s.blocked_channels = [18, 19]
		@s.blocked_channels_count = 2
		@s.browse_channels = [15, 14, 17, 1, 17]
		@s.browse_channels_count = 5
		expect(@s.min_no_of_clicks).to eq(7)

		@s.min = 103
		@s.max = 108
		@s.blocked_channels = [104]
		@s.blocked_channels_count = 1
		@s.browse_channels = [105, 106, 107, 103, 105]
		@s.browse_channels_count = 5
		expect(@s.min_no_of_clicks).to eq(8)

		@s.min = 1
		@s.max = 100
		@s.blocked_channels = [78, 79, 80, 3]
		@s.blocked_channels_count = 4
		@s.browse_channels = [10, 13, 13, 100, 99, 98, 77, 81]
		@s.browse_channels_count = 8
		expect(@s.min_no_of_clicks).to eq(12)

		@s.min = 1
		@s.max = 200
		@s.blocked_channels = []
		@s.blocked_channels_count = 0
		@s.browse_channels = [1, 100, 1, 101]
		@s.browse_channels_count = 4
		expect(@s.min_no_of_clicks).to eq(7)
	end

	it "check end to end process" do
		s=Skycast.new
		s.should_receive(:gets).and_return("1 20")
		s.should_receive(:gets).and_return("2 18 19")
		s.should_receive(:gets).and_return("5 15 14 17 1 17")
		expect(s.process).to eq(7)
	end


end