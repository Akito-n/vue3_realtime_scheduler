class Types::Objects::BlankScheduleType < Types::BaseObject
  # def self.authorized?(object, context)
  #   # only show it to users with the secret_feature enabled
  #   super and context[:user_signed_in] and context[:current_user].id == object.id
  # end

  field :id, ID, null: false
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :user_id, ID, null: false
  field :mine, Boolean, null: false
  def mine
    object.user_id == context[:current_user].id
  end
  #field :role, String, null: false
  # def role
  #   User.human_attribute_name("role.#{object.role}")
  # end
end
