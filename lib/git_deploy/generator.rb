require 'thor/group'

class GitDeploy::Generator < Thor::Group
  include Thor::Actions

  def self.source_root
    File.expand_path('../templates', __FILE__)
  end

  def copy_main_hook
    directory File.expand_path('../templates', __FILE__), 'deploy'
    chmod "deploy/after_push", 0755
    chmod "deploy/after_push.rb", 0755
  end
end
