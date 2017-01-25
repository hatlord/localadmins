#!/usr/bin/env ruby
#Enumerate Local Admins

require 'tty-command'
require 'trollop'
require 'colorize'
require 'logger'


log = Logger.new('debug.log')
cmd = TTY::Command.new(output: log)

def arguments

  opts = Trollop::options do 
    version "localadmins".light_blue
    banner <<-EOS
    localadmins.rb
      EOS

        opt :hosts, "hostlist", :type => String
        opt :username, "your username", :type => String
        opt :password, "your password", :type => String
        opt :domain, "your domain", :type => String
        opt :timeout, "Specify Timeout, for example 0.2 would be 200 milliseconds. Default 0.3", :default => 0.3

        if ARGV.empty?
          puts "Need Help? Try ./localadmins --help".red.bold
        exit
      end
    end
  opts
end

def findusers(arg, cmd, log)
  hostfile = File.readlines(arg[:hosts]).map(&:chomp)

  puts "\nEnumerating Local Admins!".green.bold
  hostfile.each do |host|
    out, err = cmd.run!("winexe -U #{arg[:domain]}/#{arg[:username]}%#{arg[:password]} //#{host} 'net localgroup administrators'")
      puts "*********#{host}*************"
      puts out
      puts "*****************************\n\n"
  end
end

arg = arguments
findusers(arg, cmd, log)