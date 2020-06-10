class Mutations::AddBlankSchedule < Mutations::BaseMutation
  null true

  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true

  field :blank_schdule, Types::Objects::BlankScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(**args)
    context[:user_signed_in]
  end

  def resolve(start_at:, end_at:)
    blank_schedule = BlankSchedule.new(start_at: start_at, end_at: end_at, user: context[:current_user])
    if blank_schedule.save
      { blank_schdule: blank_schedule }
    else
      raise GraphQL::ExecutionError, blank_schedule.errors.full_messages.join(', ')
    end
  end
end
