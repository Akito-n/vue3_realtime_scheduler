class Subscriptions::CompanySchedules < Subscriptions::BaseSubscription
  argument :occupation_ids, [ID], required: true, loads: Types::Objects::OccupationType

  field :schedules, Types::Objects::ScheduleType.connection_type, null: false

  def authorized?(**args)
    context[:current_user].company?
  end

  def subscribe(occupations:)
    if occupations.present?
      entry_users = User.where(entries: Recruitement.joins(:individual_user).where(occupation: occupations))
      return {
        schedules: BlankSchedule.where(schedulable: entry_users)
      }
    end

    make_results
  end

  def update(occupations:)
    make_results
  end

  private

  def make_results
    user = context[:current_user]

    filtered_occupations = user.first_stage_individual_occupations.to_a # TODO: ここでフラグによっては全部のoccupationをとってくる
    filtered_individual_users = user.first_stage_individual_users.to_a # TODO: ここでフラグによっては全部のindividual_userをとってくる
    blank_schedules = BlankSchedule.where(schedulable: filtered_occupations + filtered_individual_users).to_a
    schedules = Schedule.where(requester: filtered_occupations).or(Schedule.where(responder: filtered_occupations)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end
end
