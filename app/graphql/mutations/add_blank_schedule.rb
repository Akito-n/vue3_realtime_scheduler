class Mutations::AddBlankSchedule < Mutations::BaseMutation
  null true

  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true

  field :blank_schedule, Types::Objects::BlankScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(**args)
    context[:user_signed_in]
  end

  def resolve(start_at:, end_at:)
    user = context[:current_user]
    blank_schedule = BlankSchedule.new(start_at: start_at, end_at: end_at, user: user)
    if blank_schedule.save
      AppSchema.subscriptions.trigger('blankSchedules', {}, {})
      {
        blank_schedule: blank_schedule
      }
    else
      set_errors(blank_schedule)
      return
    end
  end

  def set_errors(blank_schedule)
    message = blank_schedule.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
