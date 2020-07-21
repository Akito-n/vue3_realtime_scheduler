class Types::Objects::RecruitementType < Types::BaseObject
  def self.authorized?(object, context)
    super and context[:user_signed_in]
  end

  field :id, ID, null: false
  field :created_at, Types::Scalars::DateTime, null: true
  field :start_at, Types::Scalars::DateTime, null: true
  field :end_at, Types::Scalars::DateTime, null: true
  field :individual_user, Types::Objects::MemberType, null: false
  def individual_user
    Loaders::RecordLoader.for(User).load(object.individual_user_id)
  end

  field :company_user, Types::Objects::MemberType, null: false
  def company_user
    Loaders::RecordLoader.for(User).load(object.company_user_id)
  end

  field :occupation, Types::Objects::OccupationType, null: false
  def occupation
    Loaders::RecordLoader.for(Occupation).load(object.occupation_id)
  end
end
