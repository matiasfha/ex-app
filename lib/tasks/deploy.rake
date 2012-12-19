namespace :deploy do
	PRODUCTION_APP = 'dandootv'
	DEVELOP_APP		= 'dandoodev'

	desc 'Deploy to Test'
	task :test, :branch, :mensaje do |t, args| 
		system 'git add .'
		system "git commit -am #{args.mensaje}"
		system "git push dev #{args.branch}:master"
		system 'echo "Rails.cache.clear; exit" | heroku run console --app dandoodev'
	end

	desc 'Deploy develop to production'
	task :develop, :mensaje do |t, args|
		system 'git add .'
		system "git commit -am #{args.mensaje}"
		system "git push origin dev:master"
		system 'echo "Rails.cache.clear; exit" | heroku run console --app dandootv'
	end

	desc  'Deploy production'
	task :production, :mensaje do |t, args|
		system 'rake version:bump'
		system 'git add .'
		system "git commit -am #{args.mensaje}"
		system "git push origin master"
		system 'echo "Rails.cache.clear; exit" | heroku run console --app dandootv'
	end



end