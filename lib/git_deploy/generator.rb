require 'thor/group'

class GitDeploy::Generator < Thor::Group
  include Thor::Actions

  def self.source_root
    File.expand_path('../templates', __FILE__)
  end

  def copy_main_hook
    directory File.expand_path('../templates', __FILE__), 'deploy'
  end
end
