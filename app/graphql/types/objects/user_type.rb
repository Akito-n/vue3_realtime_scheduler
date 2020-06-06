class Types::Objects::UserType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    super and context[:user_signed_in] and context[:current_user].id == object.id
  end

  field :id, ID, null: false
  field :email, String, null: true
  field :name, String, null: true
  field :role, String, null: false

  def role
    User.human_attribute_name("role.#{object.role}")
  end
end
