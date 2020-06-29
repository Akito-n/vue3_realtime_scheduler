class Mutations::AddBlankSchedule < Mutations::BaseMutation
  null true

  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true
  argument :occupation_id, ID, required: false

  field :blank_schedule, Types::Objects::BlankScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(**args)
    context[:user_signed_in]
  end

  def resolve(start_at:, end_at:, occupation_id: nil)
    user = context[:current_user]
    if user.individual?
      blank_schedule = user.blank_schedules.build(start_at: start_at, end_at: end_at)
    else
      blank_schedule = Occupation.find(occupation_id || user.occupations.first.id).blank_schedules.build(start_at: start_at, end_at: end_at)
    end
    if blank_schedule.save
      AppSchema.subscriptions.trigger('schedules', {}, {})
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
