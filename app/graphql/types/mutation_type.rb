module Types
  class MutationType < Types::BaseObject
    field :add_blank_schedule, mutation: Mutations::AddBlankSchedule
    field :edit_blank_schedule, mutation: Mutations::EditBlankSchedule
    field :destroy_blank_schedule, mutation: Mutations::DestroyBlankSchedule
    field :edit_user, mutation: Mutations::EditUser
    field :request_schedule_to_occupation, mutation: Mutations::RequestScheduleToOccupation
    field :request_schedule_to_individual_user, mutation: Mutations::RequestScheduleToIndividualUser
    field :respond_schedule, mutation: Mutations::RespondSchedule
  end
end
