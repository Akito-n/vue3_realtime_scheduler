class Subscriptions::IndividualSchedules < Subscriptions::BaseSubscription
  field :schedules, Types::Objects::ScheduleType.connection_type, null: false

  def authorized?(**args)
    context[:current_user].individual?
  end

  def subscribe
    blank_schedules = BlankSchedule.where(schedulable: context[:current_user].individual_schedulables).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end

  def update
    blank_schedules = BlankSchedule.where(schedulable: context[:current_user].individual_schedulables).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end
end
