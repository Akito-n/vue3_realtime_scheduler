# == Schema Information
#
# Table name: blank_schedules
#
#  id         :uuid             not null, primary key
#  end_at     :datetime
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_blank_schedules_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class BlankSchedule < ApplicationRecord
  belongs_to :user
end
