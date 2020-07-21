class Mutations::RequestScheduleToOccupation < Mutations::BaseMutation
  null true

  argument :occupation_id, ID, required: true, loads: Types::Objects::OccupationType
  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true

  field :schedule, Types::Objects::ScheduleType, null: true

  def authorized?(occupation:, **args)
    context[:user_signed_in] && context[:current_user].individual? && occupation.present? && context[:current_user].company_occupations.exists?(occupation.id)
  end

  def resolve(occupation:, start_at:, end_at:, **args)
    user = context[:current_user]
    schedule = user.request_schedules.build(start_at: start_at, end_at: end_at, responder: occupation, occupation: occupation)
    if schedule.save
      subscription_trigger
      {
        schedule: schedule
      }
    else
      set_errors(schedule)
      return
    end
  end

  def set_errors(schedule)
    message = schedule.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
