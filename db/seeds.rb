# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: 'TV Comedy')
drama  = Category.create(name: 'TV Drama')

Video.create(title: "Monk", description: "Lorem impsum...", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category: drama)
Video.create(title: "South Park", description: "Cartoon TV Series with some crazy kids!", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: "Family Guy", description: "Comedy Cartoon TV Series for mature audience", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: "South Park", description: "Cartoon TV Series with some crazy kids!", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: "Futurama", description: "Comedy Cartoon TV Series about space travel", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: "Family Guy", description: "Comedy Cartoon TV Series for mature audience", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: "Futurama", description: "Comedy Cartoon TV Series about space travel", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)
Video.create(title: "South Park", description: "Cartoon TV Series with some crazy kids!", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg", category: comedy)

User.create(email: 'user@sample.com', password: 'pwd', fullname: 'Sample User')

Review.create(body: "This is simply awesome! Must watch!", rating: 5, creator: User.first, video: Video.first)
Review.create(body: "This is a load of nonsense. Skip it.", rating: 1, creator: User.first, video: Video.first)

