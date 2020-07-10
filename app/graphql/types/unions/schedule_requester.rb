class Types::Unions::ScheduleRequester < Types::BaseUnion
  possible_types Types::Objects::MemberType, Types::Objects::OccupationType

  def self.resolve_type(object, context)
    if object.is_a?(Occupation)
      Types::Objects::OccupationType
    else
      Types::Objects::MemberType
    end
  end
end
