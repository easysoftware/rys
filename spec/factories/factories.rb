FactoryBot.define do
  factory :user, aliases: [:author]  do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    login { "#{firstname}-#{lastname}".downcase }
    sequence(:mail) {|n| "user#{n}@test.com" }
    admin false
    language 'en'
    status 1
    mail_notification 'only_my_events'

    easy_user_type

    # easy_user_type_id 1

    after(:create) do |user, _evaluator|
      pref = user.pref
      pref.last_easy_attendance_arrival_date = user.today
      pref.save
    end

    trait :admin do
      firstname 'Admin'
      admin true
    end

    factory :admin_user, traits: [:admin]

  end

  factory :easy_user_type do
    sequence(:name) { |n| "test_easy_user_type_#{n}" }
    is_default false
    internal true

    trait :admin do
      is_default true
    end

    factory :test_easy_user_type

  end


end
