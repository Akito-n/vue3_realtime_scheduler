#MemberType は 応募した相手
class Types::Objects::MemberType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    super and context[:user_signed_in] and context[:current_user].members_array.include?(object)
  end

  field :id, ID, null: false
  field :email, String, null: true
  field :name, String, null: true
  field :company_name, String, null: true
  field :color, String, null: false
  field :role, String, null: false

  def role
    User.human_attribute_name("role.#{object.role}")
  end
end
