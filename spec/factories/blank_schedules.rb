# == Schema Information
#
# Table name: blank_schedules
#
#  id               :uuid             not null, primary key
#  end_at           :datetime
#  schedulable_type :string           not null
#  start_at         :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  schedulable_id   :uuid             not null
#
# Indexes
#
#  index_blank_schedules_on_schedulable_type_and_schedulable_id  (schedulable_type,schedulable_id)
#
FactoryBot.define do
  factory :blank_schedule do
    start_at { "2020-06-03 06:31:10" }
    end_at { "2020-06-03 06:31:10" }
    user { nil }
  end
end
