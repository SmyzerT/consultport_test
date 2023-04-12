# frozen_string_literal: true

require './currency_converter'

describe CurrencyConverter do
  include Dry::Monads[:result]

  describe '#convert' do
    let(:rates_repo) { double('RatesRepo') }
    let(:from) { 'EUR' }
    let(:to) { 'PLN' }
    let(:rate_result) { Success(2.5) }
    let(:amount) { 20.5 }

    subject(:convert) { described_class.new(rates_repo).convert(from, to, amount) }

    before do
      allow(rates_repo).to receive(:rate).with(from, to).and_return(rate_result)
    end

    it 'returns converted avount' do
      expect(convert).to be_success
      expect(convert.value!).to eql(51.25)
    end

    context 'when rates_repo returns failure result' do
      let(:rate_result) { Failure('some issue') }

      it 'returns failure rusult' do
        expect(convert).not_to be_success
        expect(convert.failure).to include("can't get rat")
        expect(convert.failure).to include('some issue')
      end
    end
  end
end
