class Types::Objects::UserType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    super and context[:user_signed_in] and context[:current_user].id == object.id
  end

  field :id, ID, null: false
  field :email, String, null: true
  field :name, String, null: true
  field :company_name, String, null: true
  field :color, String, null: false
  field :occupations, Types::Objects::OccupationType.connection_type, null: false
  field :company_occupations, Types::Objects::OccupationType.connection_type, null: false

  field :recruitements, Types::Objects::RecruitementType.connection_type, null: false

  field :role, String, null: false
  def role
    User.human_attribute_name("role.#{object.role}")
  end

  field :is_individual, Boolean, method: :individual?, null: false
  field :is_company, Boolean, method: :company?, null: false
end
