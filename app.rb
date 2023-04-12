# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)

require_relative 'currency_converter'
require_relative 'exchange_api_repo'

if ARGV.size != 3
  puts 'two currency and amount should be specified for conversion'
  exit
end

from = ARGV[0]
to = ARGV[1]

begin
  amount = Float(ARGV[2])
rescue => _e
  puts "amount should be integer or float value like: 15, 30.50 etc.., received: #{ARGV[2]}"
  exit
end

rates_repo = ExchangerateApiRepo.new
converter = CurrencyConverter.new(rates_repo)
result = converter.convert(from, to, amount)
unless result.success?
  puts "conversion failed: #{result.failure}"
  exit
end

puts "converted amount: #{result.value!} #{to}"
