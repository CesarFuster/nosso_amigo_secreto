FactoryBot.define do
 factory :campaign do
   title         { 'Nova Campanha' }
   description   { 'Descreva sua campanha...' }
   user
   status        { :pending }
   location      { "#{FFaker::Address.city}, #{FFaker::Address.street_address}"}
   event_date    { FFaker::Time.date }
   event_hour    { rand(24).to_s }
 end
end
