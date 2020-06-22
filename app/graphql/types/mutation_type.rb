module Types
  class MutationType < Types::BaseObject
    field :add_blank_schedule, mutation: Mutations::AddBlankSchedule
    field :edit_user, mutation: Mutations::EditUser
    field :request_schedule, mutation: Mutations::RequestSchedule
    field :respond_schedule, mutation: Mutations::RespondSchedule
  end
end
