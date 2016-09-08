require_relative '../config/environment.rb'

[Customer, Review, Restaurant, Owner].each do |model|
  model.create_table
  model.drop_table
  model.create_table
end
customers = (1..10).to_a.map do |num|

  customer = Customer.new(name: Faker::Book.author, 
        birth_year: rand(1920..1990),
        hometown: Faker::Address.city)
end

customers.each do |customer|
  customer.save
end

owners = (1..10).to_a.map do |num|

  owner = Owner.new(name: Faker::Book.author, 
        birth_year: rand(1920..1990),
        hometown: Faker::Address.city)
end

owners.each do |owner|
  owner.save
end

restaurants = Owner.all.map do |owner|
  restaurant = Restaurant.new(owner_id: owner.id, name: Faker::Book.author, location: Faker::Address.city)

  other_restaurant = Restaurant.new(owner_id: owner.id, name: Faker::Book.author, location: Faker::Address.city)
  [restaurant, other_restaurant]
end.flatten

restaurants.each do |restaurant|
  restaurant.save
end

restaurant_ids = Restaurant.all.map { |g| g.id }.cycle.each

reviews = Customer.all.map.with_index(1) do |customer, index|
  
  restaurant_id = restaurant_ids.next
  review = Review.new(restaurant_id: restaurant_id, customer_id: customer.id)
  restaurant_id = restaurant_ids.next
  other_review = Review.new(restaurant_id: restaurant_id, customer_id: customer.id)
  [review, other_review]
end.flatten

reviews.each do |gb|
  gb.save
end

