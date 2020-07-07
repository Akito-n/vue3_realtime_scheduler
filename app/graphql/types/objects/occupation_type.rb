#MemberType は 応募した相手
class Types::Objects::OccupationType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    super and context[:user_signed_in]
  end

  field :id, ID, null: false
  field :address, String, null: true
  field :company_name, String, null: true
  field :name, String, null: true
  field :memo, String, null: true
  field :item, String, null: true
  field :apply_from, String, null: true
  field :required_time, String, null: true

  field :apply_from, String, null: true
  def apply_from
    Occupation.human_attribute_name("apply_from.#{object.apply_from}")
  end
end
