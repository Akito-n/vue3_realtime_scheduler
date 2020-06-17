module Types
  class MutationType < Types::BaseObject
    field :add_blank_schedule, mutation: Mutations::AddBlankSchedule
    field :edit_user, mutation: Mutations::EditUser
    field :request_schedule, mutation: Mutations::RequestSchedule
  end
end
