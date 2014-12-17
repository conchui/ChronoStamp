FactoryGirl.define do 

  factory :user do
    first_name 'Rhodel'
    last_name 'Perez'
    email 'conchui.perez@gmail.com'
    password 'password'
    password_confirmation 'password'
  end
end