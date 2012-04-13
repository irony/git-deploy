#!/usr/bin/env ruby
OLDREV, NEWREV = ARGV

require "erb"
require "pp"

USER    = ENV["USER"]
APPROOT = "#{Dir.home}/app"
die "Missing #{APPROOT} directory" unless File.directory?(APPROOT)

PORT = 10000 + (Process.uid-1000) * 1000
puts "Ports: #{PORT.inspect}"

def sys(cmd)
  puts cmd
  system cmd
end

def sys!(cmd)
  sys cmd
  raise "Command failed with #{$?.exitstatus}: #{cmd}" unless $?.success?
end

module Deployment
  extend self
  
  def bundled?
    File.file? 'Gemfile'
  end

  def rake_cmd
    @rake_cmd ||= bundled? ? 'bundle exec rake' : 'rake'
  end

  def rake(*tasks)
    unless File.file? 'Rakefile'
      puts "Skipping rake task #{tasks.join(' ')}: no Rakefile"
      return
    end

    rails_env = ENV['RAILS_ENV'] || 'production'
    sys "#{rake_cmd} #{tasks.join(' ')} RAILS_ENV=#{rails_env}" if tasks.any?
  end
  
  FOREMAN_CONCURRENCY_DEFAULT = "web=2"
  
  def foreman_concurrency
    @foreman_concurrency ||= begin
      path = "#{Dir.home}/foreman.concurrency"
      File.read(path).grep(/^[^#]/).grep(/./).first.chomp
    rescue Errno::ENOENT
      puts "*** Missing file #{path}; falling back to default #{FOREMAN_CONCURRENCY_DEFAULT.inspect}"
      FOREMAN_CONCURRENCY_DEFAULT
    end.tap do |concurrency|   
      puts "*** foreman concurrency: #{concurrency.inspect}"
    end
  end

  def instance_config
    Hash[ *foreman_concurrency.split(/[=,]/) ].tap do |config|
      config.default = 1
    end
  end
end

Dir.glob("#{File.dirname(__FILE__)}/deployment/*.rb").sort.each do |file|
  puts "=== #{File.basename(file)} ===================================="
  load file
  puts "=== #{File.basename(file)} done"
end
