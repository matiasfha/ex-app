# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Sex.destroy_all
MaritalStatus.destroy_all
City.destroy_all
Country.destroy_all
Interest.destroy_all
User.destroy_all
Occupation.destroy_all

sexes = Sex.create([{ name: 'Femenino' }, { name: 'Masculino' }, { name: 'No Especificado' }])
marital_statuses = MaritalStatus.create([{ name: 'Soltero(a)' }, { name: 'Casado(a)' }, { name: 'Viudo(a)' }, { name: 'Otro' }, { name: 'No Especificado' }])
cities = City.create([{ name: 'Santiago' }])
countries = Country.create([{ name: 'Chile' }])
interests = Interest.create([{ name: 'Animales' }, { name: 'Deporte' }, { name: 'Cine' }, { name: 'Televisi&oacute;n Nacional' }])

users = User.create([{ first_name: 'Max', last_name: 'Findel', email: 'maxfindel@gmail.com', rut: '17.847.216-k', image: 'http://graph.facebook.com/537367691/picture?type=square', active: true, password: 'alzheimer', password_confirmation: 'alzheimer', random_pass: 'alzheimer' }])
ocupation = Occupation.create([{ name: 'Programador', user: users.first }])






