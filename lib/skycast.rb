#!/usr/bin/env ruby
#main program

require File.expand_path(File.join(File.dirname(__FILE__), 'remote_control.rb'))

while (true)
	RemoteControl.new.process
	puts "Press 1 to continue and 0 to exit"
	exit_control = gets.chomp
	break if exit_control == '0'
end