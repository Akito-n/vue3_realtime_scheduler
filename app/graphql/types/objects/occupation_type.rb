#MemberType は 応募した相手
class Types::Objects::OccupationType < Types::BaseObject
  def self.authorized?(object, context)
    # only show it to users with the secret_feature enabled
    super and context[:user_signed_in]
  end

  field :id, ID, null: false
  field :name, String, null: true
end
