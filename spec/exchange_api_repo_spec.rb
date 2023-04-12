# frozen_string_literal: true

require './exchange_api_repo'

describe ExchangerateApiRepo do
  describe '#rate' do
    let(:from) { 'EUR' }
    let(:to) { 'PLN' }
    let(:rates_status) { 200 }
    let(:rates_body) do
      {
        'rates' => {
          'EUR' => 0.5,
          'PLN' => 2.2
        }
      }.to_json
    end

    before do
      stub_request(:get, 'https://open.er-api.com/v6/latest/USD')
        .to_return(
          status: rates_status,
          body: rates_body,
          headers: { 'Content-Type': 'application/json' }
        )
    end

    subject(:rate_result) { described_class.new.rate(from, to) }

    it 'returns exchange rate' do
      expect(rate_result).to be_success
      expect(rate_result.value!).to eql(4.4)
    end

    context 'when currencies passed in lowercase' do
      let(:from) { 'eur' }
      let(:to) { 'pln' }

      it 'returns exchange rate' do
        expect(rate_result).to be_success
        expect(rate_result.value!).to eql(4.4)
      end
    end

    context 'when rates request fails' do
      let(:rates_status) { 400 }

      it 'return failure result' do
        expect(rate_result).not_to be_success
        expect(rate_result.failure).to include('failed to fetch currency rates')
      end
    end

    context 'when undefined currency' do
      let(:from) { 'FOO' }

      it 'return failure result' do
        expect(rate_result).not_to be_success
        expect(rate_result.failure).to include('undefined currency')
      end
    end
  end
end
