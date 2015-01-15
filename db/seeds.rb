# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Video.create(title: "Monk", description: "Lorem impsum...", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")

Video.create(title: "Family Guy", description: "Comedy Cartoon TV Series for mature audience", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")

Video.create(title: "South Park", description: "Cartoon TV Series with adult humor", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg")
