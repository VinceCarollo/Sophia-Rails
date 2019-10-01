FactoryBot.define do
  factory :list do
    sequence :name {|n| "list name #{n}" }
    created_for { 'caretaker' }
    client
    caretaker
  end
end
