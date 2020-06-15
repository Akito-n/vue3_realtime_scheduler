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

  validate :check_schedule
  validates_with CheckScheduleValidator

  def check_schedule
    if start_at > end_at
      errors.add(:start_at,'は終了時間よりも前に設定してください。')
    end
  end
end
