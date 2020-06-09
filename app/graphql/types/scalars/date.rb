class Types::Scalars::Date < GraphQL::Schema::Scalar
  description 'Date'
  def self.coerce_input(value, _context)
    Date.parse(value)
  end
  def self.coerce_result(value, _context)
    # I18n.l(value, format: :default)
    value
  end
end
