class Subscriptions::Schedules < Subscriptions::BaseSubscription
  argument :occupation_ids, [ID], required: true, loads: Types::Objects::OccupationType

  field :schedules, Types::Objects::ScheduleType.connection_type, null: false

  # def authorized?(**args)
  #   true
  # end

  def subscribe(occupations:)
    if occupations.present?
      entry_users = User.where(entries: Recruitement.joins(:individual_user).where(occupation: occupations))
      return {
        schedules: BlankSchedule.where(schedulable: entry_users)
      }
    end
    blank_schedules = BlankSchedule.where(schedulable: context[:current_user].schedulable_array).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end

  def update(occupations:)
    blank_schedules = BlankSchedule.where(schedulable: context[:current_user].schedulable_array).to_a
    schedules = Schedule.where(requester: context[:current_user].my_schedulable_array).or(Schedule.where(responder: context[:current_user].my_schedulable_array)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end
end
