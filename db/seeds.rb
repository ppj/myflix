# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Video.find_by(title: 'Family Guy').category = Category.create(name: 'TV Comedy')

Video.find_by(title: 'South Park').category = Category.find_by(name: 'TV Comedy')

Video.find_by(title: 'Monk').category = Category.create(name: 'TV Drama')
