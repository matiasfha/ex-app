mongo: mongod run --config /usr/local/Cellar/mongodb/2.0.4-x86_64/mongod.conf
web: bundle exec unicorn  -p 8080 -c ./config/unicorn.rb
delayed_job: rake jobs:work