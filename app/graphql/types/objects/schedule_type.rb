class Types::Objects::ScheduleType < Types::BaseObject
  def self.authorized?(object, context)
    super and context[:user_signed_in] and object.authorized?(context[:current_user])
  end

  field :id, ID, null: false
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :mine, Boolean, null: false
  field :status, String, null: false
  field :requester, Types::Objects::MemberType, null: false
  field :responder, Types::Objects::MemberType, null: false

  field :is_request, Boolean, null: false
  def is_request
    object.class.name == 'Schedule'
  end

  def mine
    object.requester_id == context[:current_user].id
  end

  def status
    Schedule.human_attribute_name("status.#{object.status}")
  end
end
