# frozen_string_literal: true

# spec/models/finance_record_spec.rb

require 'rails_helper'

RSpec.describe FinanceRecord, type: :model do
  describe '.process_finance_data' do
    let(:single_record_data) do
      [{
        'name'                => 'John Doe',
        'party'               => 'REP',
        'state'               => '/races/CO.json',
        'total_contributions' => 5000,
        'total_disbursements' => 3000,
        'end_cash'            => 2000
      }]
    end

    let(:multiple_record_data) do
      single_record_data + [{
        'name'                => 'Jane Smith',
        'party'               => 'DEM',
        'state'               => '/races/NY.json',
        'total_contributions' => 7000,
        'total_disbursements' => 4000,
        'end_cash'            => 3000
      }]
    end

    context 'with single record' do
      subject(:single_record) { described_class.process_finance_data(single_record_data).first }

      it { is_expected.to have_attributes(name: 'John Doe', party: 'REP', state: 'CO') }
      it { is_expected.to have_attributes(total_contributions: 5000, total_disbursements: 3000, end_cash: 2000) }
    end

    context 'with multiple records' do
      subject(:multiple_records) { described_class.process_finance_data(multiple_record_data) }

      it { is_expected.to all(be_a(described_class)) }

      it 'creates the correct number of records' do
        expect(multiple_records.length).to eq(2)
      end
    end
  end

  describe '.extract_state' do
    it 'extracts the state abbreviation from a URL' do
      expect(described_class.extract_state('/races/CO.json')).to eq('CO')
    end

    it 'returns N/A for nil URL' do
      expect(described_class.extract_state(nil)).to eq('N/A')
    end
  end
end
