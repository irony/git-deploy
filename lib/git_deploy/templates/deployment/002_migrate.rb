num_migrations = `git diff #{OLDREV} #{NEWREV} --diff-filter=A --name-only -z -- db/migrate`.split("\0").size
Deployment.rake "db:migrate" if num_migrations > 0
