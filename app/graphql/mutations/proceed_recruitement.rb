class Mutations::ProceedRecruitement < Mutations::BaseMutation
  null true

  argument :recruitement_id, ID, required: true, loads: Types::Objects::RecruitementType

  field :recruitement, Types::Objects::RecruitementType, null: true

  def authorized?(recruitement:, **args)
    context[:user_signed_in]
  end

  def resolve(recruitement:, **input)
    if recruitement.update(is_fixed: false)
      subscription_trigger
      {
        recruitement: recruitement
      }
    else
      set_errors(recruitement)
      return
    end
  end

  def set_errors(recruitement)
    message = recruitement.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
