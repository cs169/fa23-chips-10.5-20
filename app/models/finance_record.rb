# frozen_string_literal: true

class FinanceRecord
  attr_reader :name, :party, :state, :total_contributions, :total_disbursements, :end_cash

  def initialize(attributes={})
    @name = attributes[:name]
    @party = attributes[:party]
    @state = attributes[:state]
    @total_contributions = attributes[:total_contributions]
    @total_disbursements = attributes[:total_disbursements]
    @end_cash = attributes[:end_cash]
  end

  # Process raw finance data from the API
  def self.process_finance_data(finance_data)
    finance_data.map do |record|
      new(
        name:                record['name'],
        party:               record['party'],
        state:               extract_state(record['state']),
        total_contributions: record['total_contributions'],
        total_disbursements: record['total_disbursements'],
        end_cash:            record['end_cash']
      )
    end
  end

  # Extract the state abbreviation from the provided state URL
  def self.extract_state(state_url)
    # Check if state_url is present
    if state_url
      state_url.split('/').last.gsub('.json', '').upcase
    else
      'N/A' # or any other default value you deem appropriate
    end
  end
end
