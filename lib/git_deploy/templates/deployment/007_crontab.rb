#
# rebuild upstart config and restart upstart services
if File.file?("#{APPROOT}/config/crontab.erb")
  run "erb #{APPROOT}/config/crontab.erb | crontab -"
  puts "Installed crontab"
end
