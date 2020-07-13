class Types::Objects::RecruitementType < Types::BaseObject
  def self.authorized?(object, context)
    super and context[:user_signed_in]
  end

  field :id, ID, null: false
  field :created_at, Types::Scalars::DateTime, null: true
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :individual_user, Types::Objects::MemberType, null: false
  field :company_user, Types::Objects::MemberType, null: false
  field :occupation, Types::Objects::OccupationType, null: false
end
