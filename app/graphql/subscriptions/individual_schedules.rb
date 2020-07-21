class Subscriptions::IndividualSchedules < Subscriptions::BaseSubscription
  field :schedules, Types::Objects::ScheduleType.connection_type, null: false

  def authorized?(**args)
    context[:current_user].individual?
  end

  def subscribe
    make_results
  end

  def update
    make_results
  end

  def make_results
    filtered_schedulables = [context[:current_user], context[:current_user].unsettled_company_occupations]
    blank_schedules = BlankSchedule.where(schedulable: filtered_schedulables).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end
end
