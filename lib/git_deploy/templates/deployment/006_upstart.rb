#
# rebuild upstart config and restart upstart services
procfile = "#{APPROOT}/Procfile.16b"
procfile = "#{APPROOT}/Procfile" unless File.exist?(procfile)

sys "/sbin/stop #{USER}"
sys "foreman export upstart ~/.init --app #{USER} -t #{File.dirname(__FILE__)}/foreman.user-upstart --log #{APPROOT}/log -p #{PORT} -d #{APPROOT} -f #{procfile} -c #{Deployment.foreman_concurrency}"
sys "/sbin/start #{USER}"
