changed_assets = `git diff #{OLDREV} #{NEWREV} --name-only -z -- app/assets`.split("\0")
Deplyoment.rake "assets:precompile" if changed_assets.size > 0
