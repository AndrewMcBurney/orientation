# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    label { Faker::Lorem.sentence }
  end
end
