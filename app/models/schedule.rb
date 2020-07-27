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
    ActiveRecord::Base.transaction do
      recruitement = occupation.recruitements.find_by(individual_user_id: self.respond_individual_user_id)
      recruitement.update!(stage_count: recruitement.stage_count + 1, is_fixed: true )
      update!(accepted_at: Time.zone.now, status: :accept)
      Schedule.not_status_accept.where(requester: requester, responder: responder).or(Schedule.not_status_accept.where(responder: requester, requester: responder)).delete_all
      BlankSchedule.hollow_out!([requester, responder], start_at: start_at, end_at: end_at)
    end
  end

  def reject!
    status_reject!
    BlankSchedule.hollow_out!(responder, start_at: start_at, end_at: end_at)
  end

  def can_read?(user)
    can_request?(user) || can_response?(user)
  end

  def can_request?(user)
    user.my_schedulable_array.include?(requester)
  end

  alias_method :can_write?, :can_request?

  def can_response?(user)
    user.my_schedulable_array.include?(responder)
  end

  def respond_individual_user_id
    requester_type == 'User' ? requester_id : responder_id
  end
end
