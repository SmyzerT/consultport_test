# frozen_string_literal: true

class CurrencyConverter
  include ::Dry::Monads[:result]

  attr_reader :currency_rate_repo

  def initialize(currency_rate_repo)
    @currency_rate_repo = currency_rate_repo
  end

  def convert(from, to, amount)
    rate_result = currency_rate_repo.rate(from, to)
    return Failure("can't get rate: #{rate_result.failure}") unless rate_result.success?

    Success(amount * rate_result.value!)
  end
end
