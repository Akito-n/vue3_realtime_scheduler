class Mutations::RequestScheduleToIndividualUser < Mutations::BaseMutation
  null true

  argument :individual_user_id, ID, required: true, loads: Types::Objects::MemberType
  argument :occupation_id, ID, required: true, loads: Types::Objects::OccupationType
  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true

  field :schedule, Types::Objects::ScheduleType, null: true

  def authorized?(individual_user:, occupation:, **args)
    context[:user_signed_in] && context[:current_user].company? && occupation.present?
  end

  def resolve(individual_user:, occupation:, start_at:, end_at:, **args)
    schedule = occupation.request_schedules.build(start_at: start_at, end_at: end_at, responder: individual_user, occupation: occupation)
    if schedule.save
      AppSchema.subscriptions.trigger('schedules', { occupation_ids: [] }, {})
      AppSchema.subscriptions.trigger('individual_tasks', {}, {})
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
