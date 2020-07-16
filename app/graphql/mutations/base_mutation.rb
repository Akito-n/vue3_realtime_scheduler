module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject


    def subscription_trigger
      AppSchema.subscriptions.trigger('individual_schedules', {}, {})
      AppSchema.subscriptions.trigger('company_schedules', { occupation_ids: [], user_ids: [] }, {})
      AppSchema.subscriptions.trigger('individual_tasks', {}, {})
      AppSchema.subscriptions.trigger('company_tasks', {}, {})
    end
  end
end
