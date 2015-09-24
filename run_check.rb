#!/usr/bin/env ruby
#/ Usage: run_check --check <CHECK_NAME>
#/ Generic script to run simple monitoring checks
$stderr.sync = true
require 'bundler/setup'
require 'optparse'
require 'rubygems'
require 'syslog/logger'
require 'trollop'
require_relative 'helpers/check_helper'
require_relative 'helpers/notification_helper'

Bundler.require
available_checks = import_checks()
avaliable_notifications = import_notifications()

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
  opt :notification_name, "The name of the notification type you wish to send",
      :type => String
  opt :delimiter, "Delimiter to use when splitting params", :default => '|'
  opt :verbose, "Verbose check output", :default => false
  opt :very_verbose, "Verbose notification output", :default => false
end

Trollop::die :check_name, "must be a supplied" if (opts[:check_name] == nil)

#Parameter validation. Ensure the check requested is available.
check_clazz = nil
available_checks.each do | _check |
  if _check.respond_to?(:name)
    if _check.name. == opts[:check_name]
      check_clazz = _check
      break
    end
  end
end

#And the requested notification
notif_clazz = nil
avaliable_notifications.each do | _notif |
  if _notif.respond_to?(:name)
    if _notif.name. == opts[:notification_name]
      notif_clazz = _notif
      break
    end
  end
end

if check_clazz.nil?
  puts "Unable to find any check by name: #{opts[:check_name]}. Available checks: #{available_checks.inspect}"
  exit(1)
end

if notif_clazz.nil? and not opts[:notification_name].nil?
  puts "Unable to find any notification type by name: #{opts[:notification_name]}. Available checks: #{avaliable_notifications.inspect}"
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
  "CHECK ARGUMENT ERROR: #{arg_error.message}"
  puts check.help
  exit(2)
end

if check.failed?
  log.error("CHECK FAILED: #{check.output}")
  puts "CHECK FAILED"
  if opts[:verbose]
    puts "#{check.output}"
  end
  exit_code = 1
else
  log.info("CHECK SUCCEEDED: #{check.class.name} - #{check.output}")
  puts "CHECK SUCCEEDED"
  if opts[:verbose]
    puts "#{check.output}"
  end
  exit_code = 0
end

if not notif_clazz.nil?
  notif = notif_clazz.new()
  begin
    notif.send(check_params, check)
    if notif.failed?
      puts "\nNOTIFICATION FAILED"
    else
      puts "\nNOTIFICATION SUCCEEDED"
    end
    if opts[:very_verbose]
      puts notif.output
    end
  rescue ArgumentError => arg_error
    puts "\nNOTIFICATION ARGUMENT ERROR: #{arg_error.message}"
    puts notif.help
  end
end

exit(exit_code)