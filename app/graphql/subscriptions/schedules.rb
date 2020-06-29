class Subscriptions::Schedules < Subscriptions::BaseSubscription
  #argument :question_id, ID, required: true, loads: Types::QueryType

  field :schedules, Types::Objects::ScheduleType.connection_type, null: false

  # def authorized?(**args)
  #   true
  # end

  def subscribe
    blank_schedules = BlankSchedule.where(scheduleble: context[:current_user].schedulable_array).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end

  def update
    blank_schedules = BlankSchedule.where(scheduleble: context[:current_user].schedulable_array).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end
end
