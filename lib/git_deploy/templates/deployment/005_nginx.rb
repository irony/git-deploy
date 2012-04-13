# A binding to recreate the nginx server configuration
module NginxEnvironment
  def self.ports
    PORT...(PORT+Deployment.instance_config["web"].to_i)
  end

  def self.server_names
    [ "#{USER}.16b.org" ]
  end

  def self.root
    APPROOT
  end

  def self.binding
    super
  end
end

puts "nginx: setting up #{USER} to run on #{NginxEnvironment.ports.inspect}"

config_path = "#{APPROOT}/config/nginx.conf"
template = File.read("#{APPROOT}/config/nginx.conf.erb")
config = ERB.new(template).result(NginxEnvironment.binding) 
File.open(config_path, "w") { |file| file.write(config) }

sys "sudo /etc/init.d/nginx restart"
