#!/usr/bin/env ruby
#/ Usage: run_check --check <CHECK_NAME>
#/ Generic script to run simple monitoring checks
$stderr.sync = true
require 'bundler/setup'
require 'optparse'
require 'rubygems'
require 'syslog/logger'
require 'trollop'
require_relative 'check_helper'

Bundler.require
available_checks = import_checks()

log = Syslog::Logger.new 'run_check'

opts = Trollop::options do
  version "Check 0.0.1 2015 Ben Bettridge"
  banner <<-EOS
Check is a small script that can execute simple monitoring checks

Usage:
       check [options] param1|value param2|value
where [options] are:
  EOS

  opt :check_name, "The name of the check you wish to run",
      :type => String
  opt :delimiter, "Delimiter to use when splitting params", :default => '|'
  opt :verbose, "Use verbose output", :default => false
end

Trollop::die :check_name, "must be a supplied" if (opts[:check_name] == nil)

#Parameter validation. Ensure the check requested is available.
check_clazz = NIL
available_checks.each do | _check |
  if _check.respond_to?(:name)
    if _check.name. == opts[:check_name]
      check_clazz = _check
      break
    end
  end
end
if check_clazz.nil?
  puts "Unable to find any check by name: #{opts[:check_name]}. Available checks: #{available_checks.inspect}"
  exit(1)
end

#Parse out params intended to be passed through to the check.
check_params = {}
ARGV.each do | arg |
  params = arg.split(opts[:delimiter])
  if params.size == 2
    check_params[params[0]] = params[1]
  end
end

#Create an instance and run the checks.
check = check_clazz.new()
begin
  check.execute(check_params)
rescue ArgumentError => arg_error
  puts "ERROR: #{arg_error.message}"
  puts check.help
  exit(2)
end

if check.failed?
  log.error("CHECK FAILED: #{check.output}")
  Pony.mail(:to => 'ben.bettridge@example.com', :from => 'alerts@example.com', :subject => "CHECK FAILURE: #{check.class.name}", :body => check.output)
  puts "FAILED"
  if opts[:verbose]
    puts "#{check.output}"
  end
  exit(1)
else
  log.info("CHECK SUCCEEDED: #{check.class.name} - #{check.output}")
  puts "SUCCESS"
  if opts[:verbose]
    puts "#{check.output}"
  end
  exit()
end

