class Types::Objects::ScheduleType < Types::BaseObject
  def self.authorized?(object, context)
    super and context[:user_signed_in] and object.can_read?(context[:current_user])
  end

  field :id, ID, null: false
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :mine, Boolean, null: false
  field :status, String, null: false
  field :requester, Types::Objects::MemberType, null: false
  field :responder, Types::Objects::MemberType, null: false
  field :occupation, Types::Objects::OccupationType, null: false

  field :is_request, Boolean, null: false
  def is_request
    object.class.name == 'Schedule'
  end

  def mine
    if context[:current_user].individual?
      object.requester_id == context[:current_user].id
    else
      context[:current_user].occupations.include?(object.requester)
    end
  end

  def status
    Schedule.human_attribute_name("status.#{object.status}")
  end
end
