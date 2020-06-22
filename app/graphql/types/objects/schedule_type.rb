class Types::Objects::ScheduleType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    if object.class.name == 'Schedule'
      super and context[:user_signed_in] and (context[:current_user].id == object.requester_id || context[:current_user].id == object.responder_id)
    elsif object.class.name == 'BlankSchedule'
      super and object.user.members_array.include?(context[:current_user])
    end
  end

  field :id, ID, null: false
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :mine, Boolean, null: false
  field :requester, Types::Objects::MemberType, null: false
  field :responder, Types::Objects::MemberType, null: false

  field :is_request, Boolean, null: false
  def is_request
    object.class.name == 'Schedule'
  end

  def mine
    object.requester_id == context[:current_user].id
  end

end
