class Types::Objects::ScheduleType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    super and context[:user_signed_in] and (context[:current_user].id == object.requester_id || context[:current_user].id == object.responder_id)
  end

  field :id, ID, null: false
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :requester, Types::Objects::MemberType, null: false
  field :responder, Types::Objects::MemberType, null: false
end
