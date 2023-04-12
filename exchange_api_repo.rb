# frozen_string_literal: true

class ExchangerateApiRepo
  include ::Dry::Monads[:result]

  def rate(from, to)
    from = from.to_s.upcase
    to = to.to_s.upcase

    rate_result = fetch_rates
    return Failure("failed to fetch currency rates: #{rate_result.failure}") unless rate_result.success

    rates = rate_result.value!
    [from, to].each do |curr|
      return Failure("undefined currency: #{curr}") unless rates[curr]
    end

    from_rate = rates[from]
    to_rate = rates[to]
    Success(to_rate / from_rate)
  end

  private

  def fetch_rates
    response = transport.get('USD')
    return Failure("failed to fecth data: response status #{response.status}") if response.status != 200

    rates = response.body['rates']
    rates ? Success(rates) : Failure('no rates in the response')
  end

  def transport
    Faraday.new 'https://open.er-api.com/v6/latest/' do |conn|
      conn.options.timeout = 5
      conn.response :json
    end
  end
end
