# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#CLEAN database
User.all.destroy
City.all.destroy
Commune.all.destroy
State.all.destroy
Country.all.destroy
CivilStatus.all.destroy
Genero.all.destroy
Authentication.all.destroy

AdminUser.create :email => 'development@dandoo.tv', :password => 'admin123', :password_confirmation => 'admin123'
