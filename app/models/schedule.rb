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
class Schedule < ApplicationRecord
  belongs_to :requester, polymorphic: true
  belongs_to :responder, polymorphic: true
  belongs_to :occupation

  enum status: { pending: 0, accept: 1, reject: 2 }, _prefix: true

  def accept!
    update!(accepted_at: Time.zone.now, status: :accept)
    BlankSchedule.hollow_out!([requester, responder], start_at: start_at, end_at: end_at)
  end

  def reject!
    status_reject!
    BlankSchedule.hollow_out!(responder, start_at: start_at, end_at: end_at)
  end

  def authorized?(user)
    user.my_schedulable_array.include?(requester) || user.my_schedulable_array.include?(responder)
  end
end
