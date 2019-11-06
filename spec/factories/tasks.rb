FactoryBot.define do
  factory :task do
    title { 'a title' }
    description { 'a descritpion' }
    due_date { Time.zone.parse('2019-11-03 22:08:24') }
    status { Task.statuses[:in_progress] }
    user
  end
end
