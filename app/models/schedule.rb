# == Schema Information
#
# Table name: schedules
#
#  id           :uuid             not null, primary key
#  accepted_at  :datetime
#  approved_at  :datetime
#  end_at       :datetime
#  start_at     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requester_id :uuid             not null
#  responder_id :uuid             not null
#
# Indexes
#
#  index_schedules_on_requester_id_and_responder_id  (requester_id,responder_id)
#
# Foreign Keys
#
#  fk_rails_...  (requester_id => users.id)
#  fk_rails_...  (responder_id => users.id)
#
class Schedule < ApplicationRecord
  belongs_to :requester, class_name: :User
  belongs_to :responder, class_name: :User

  validates :requester_id, uniqueness: { scope: :responder_id }

  def accept!
    update!(accepted_at: Time.zone.now)
    BlankSchedule
      .where(user: [requester, responder])
      .where(start_at: start_at, end_at: end_at)
      .map(&:destroy!)
  end
end
