20.times do
  Post.create!(
    title: Faker::Creature::Animal.name,
    comment: Faker::Quote.matz,
    size: Faker::Number.between(from: 10, to: 100),
    weight: Faker::Number.between(from: 100, to: 1000),
    date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    number: Faker::Number.between(from: 1, to: 10)
  )
end