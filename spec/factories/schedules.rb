# == Schema Information
#
# Table name: schedules
#
#  id             :uuid             not null, primary key
#  accepted_at    :datetime
#  approved_at    :datetime
#  end_at         :datetime
#  requester_type :string           not null
#  responder_type :string           not null
#  start_at       :datetime
#  status         :integer          default("pending"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  occupation_id  :uuid             not null
#  requester_id   :uuid             not null
#  responder_id   :uuid             not null
#
# Indexes
#
#  index_schedules_on_occupation_id  (occupation_id)
#
# Foreign Keys
#
#  fk_rails_...  (occupation_id => occupations.id)
#
FactoryBot.define do
  factory :schedule do
    requester { nil }
    responder { nil }
    start_at { "2020-06-17 08:09:23" }
    end_at { "2020-06-17 08:09:23" }
    approved_at { "2020-06-17 08:09:23" }
  end
end
