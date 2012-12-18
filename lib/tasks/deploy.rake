namespace :deploy do

    task :production do |t,args| 
        puts "deploying to production"
        system "git add . && git commit -am '#{args[:mensaje]}'"
        system "git push origin master"
        puts "clearing cache"
        system "heroku console Rails.cache.clear --app dandootv"
        system "heroku console Dalli::Client.new.flush"
        puts "done"
    end

    task :develop do |t,args|
    	puts "deploying to develop to production"
    	system "git add . && git commit -am '#{args[:mensaje]}'"
       system "git push origin develop:master"
       puts "clearing cache"
       system "heroku console Rails.cache.clear --app dandootv"
       system "heroku console Dalli::Client.new.flush"
       puts "done"
    end

    task :test, :branch do  |t,args|
    	puts "deploying to test"
    	system "git add . && git commit -am '#{args[:mensaje]}'"
       system "git push  dev #{args[:branch]}:master"
       puts "clearing cache"
       system "heroku console Rails.cache.clear --app dandoodev"
       system "heroku console Dalli::Client.new.flush"
       puts "done"
    end



end