# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or create!d alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)
volonter = Volonter.find_or_initialize_by(email: 'volonter@example.com')
volonter.update_attributes(password: 'password', password_confirmation: 'password')

volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address
# volonter.kids.create! remote_video_url: 'http://techslides.com/demos/sample-videos/small.mp4', name: Faker::Name.name, description: Faker::Lorem.sentence(3), age: Faker::Number.between(8, 15), address: Faker::Address.street_address