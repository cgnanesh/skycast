require 'remote_control'

describe 'RemoteControlInput' do
  it 'checks no of inputs given for min and max values of channel' do
    s=RemoteControl.new
  	s.should_receive(:gets).and_return("1 10 20")
    expect { s.read_min_max_channels }.to raise_error("wrong no values for min and max channels")
    s.should_receive(:gets).and_return("0 10")
    expect { s.read_min_max_channels }.to raise_error("Min or max channel cannot be zero or greater than 10,000")
    s.should_receive(:gets).and_return("10 1")
    expect { s.read_min_max_channels }.to raise_error("Min cannot be greater than max channel")
    s.should_receive(:gets).and_return("1 10")
    s.read_min_max_channels
    expect(s.min).to eq(1)
    expect(s.max).to eq(10)
  end

  it "blocked channels validations" do
  	s=RemoteControl.new
  	s.min = 10
  	s.max = 20
  	s.should_receive(:gets).and_return("2 10 21")
  	expect { s.read_blocked_channels }.to raise_error("Blocked channel 21 is not valid channel")
  	s.max = 70
  	s.should_receive(:gets).and_return("41 51 52 53 54 55 56 57 58 59 60 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41")
  	expect { s.read_blocked_channels }.to raise_error("Blocked channels cannot be more thean 40")
  	s.should_receive(:gets).and_return("2 10 21")
  	s.read_blocked_channels
  	expect(s.blocked_channels).to eq([10,21])
  	expect(s.blocked_channels_count).to eq(2)
	end

	it "browse channels validations" do
		s=RemoteControl.new
  	s.min = 10
  	s.max = 20
  	s.blocked_channels = [14,15]
  	s.blocked_channels_count = 2
  	s.should_receive(:gets).and_return("2 10 21")
  	expect { s.read_browse_channels }.to raise_error("Browse channel 21 is not valid channel")
  	s.should_receive(:gets).and_return("2 14 18")
  	expect { s.read_browse_channels }.to raise_error("Browse channel 14 is blocked channel")
  	s.should_receive(:gets).and_return("0")
  	expect { s.read_browse_channels }.to raise_error("Browse channels count should be atleast be 1 and less than 50")

  	s.should_receive(:gets).and_return("2 13 18")
  	s.read_browse_channels
  	expect(s.browse_channels).to eq([13,18])
  	expect(s.browse_channels_count).to eq(2)
	end
end