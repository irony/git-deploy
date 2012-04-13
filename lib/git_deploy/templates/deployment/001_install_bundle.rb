if Deployment.bundled?

  bundler_args = ['--deployment']
  bundle_without = ENV['BUNDLE_WITHOUT'] || 'development:test'
  bundler_args << '--without' << bundle_without unless bundle_without.empty?

  # update gem bundle
  sys "bundle install #{bundler_args.join(' ')}"

end