FactoryBot.define do
  factory :market do
    name { Faker::Name.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.city_prefix }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
