class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    query = data["query"]
    variables = ensure_hash(data["variables"])
    operation_name = data["operationName"]
    context = {
      current_user: find_verified_user,
      user_signed_in: find_verified_user.present?,
      channel: self,
    }

    result = AppSchema.execute({
      query: query,
      context: context,
      variables: variables,
      operation_name: operation_name
    })

    payload = {
      result: result.to_h,
      more: result.subscription?,
    }

    # Track the subscription here so we can remove it
    # on unsubscribe.
    if result.context[:subscription_id]
      @subscription_ids << result.context[:subscription_id]
    end

    transmit(payload)
  end

  def unsubscribed
    @subscription_ids.each { |sid|
      AppSchema.subscriptions.delete_subscription(sid)
    }
  end

  private

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def find_verified_user
    verified_user = connection
    .env['warden'].user
    return reject_unauthorized_connection unless verified_user
    verified_user
  end
end
