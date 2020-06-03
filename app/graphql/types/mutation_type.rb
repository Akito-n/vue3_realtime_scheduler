module Types
  class MutationType < Types::BaseObject
    field :add_blank_schedule, mutation: Mutations::AddBlankSchedule
    field :edit_user, mutation: Mutations::EditUser
  end
end
