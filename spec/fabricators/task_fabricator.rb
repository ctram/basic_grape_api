Fabricator(:task) do
  content {Faker::Lorem.sentence}
  pending {true}
  reminder_id
end
