FactoryBot.define do
  factory :vendor do
    name { Faker::Name.name }
    description { Faker::Address.street_address }
    contact_name { "#{Faker::Books::Dune.title} #{Faker::Creature::Dog.name}" }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { Faker::Boolean.boolean }
  end
end
