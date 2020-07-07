# == Schema Information
#
# Table name: occupations
#
#  id            :uuid             not null, primary key
#  address       :string
#  apply_from    :integer          default("egent"), not null
#  color         :string           default("orange"), not null
#  item          :string
#  memo          :text
#  name          :string           not null
#  required_time :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_occupations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Occupation < ApplicationRecord
  belongs_to :user
  delegate :company_name, to: :user

  has_many :recruitements

  enum apply_from: { egent: 0, plus: 1 }

  has_many :blank_schedules, as: :schedulable
  has_many :request_schedules, class_name: :Schedule, as: :requester
  has_many :reseived_schedules, class_name: :Schedule, as: :responder
end
