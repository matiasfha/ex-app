namespace :heroku do
  namespace :deploy do
    task :tag do
      rev = `git rev-parse HEAD`.strip
      if `git describe --contains #{rev} 2>&1`.include?('cannot describe')
        version = Time.new.strftime("%Y%m%d%H%M%S")
        sh "rake assets:clean"
        sh "rake tmp:clear"
        sh "rm -rf tmp/"
        sh "bundle"
        #sh "RAILS_ENV=production rake assets:precompile"
        sh "git add .  && git commit -am 'Version-#{version}'"
        sh "git tag -a heroku-#{version} -m 'Deploy version to Heroku: #{version}'"
        sh "git push heroku master"
        sh "git push github master --tags"
      else
        puts "[!] The current revision is already tagged, skipping tag creation."
      end
    end
  end
  desc 'Deploys *without* running migrations'
  task :deploy => 'heroku:deploy:tag'
end