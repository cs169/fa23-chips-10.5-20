require 'rails_helper'
require 'spec_helper'

describe Representative do
  describe 'searching for representative' do
    before do
      @rep_info = OpenStruct.new(
        officials: [
          OpenStruct.new(name: 'Adam Smith'),
        ],
        offices:   [
          OpenStruct.new(name: 'Representatives', division_id: 'ocdidtest', official_indices: [0]),
        ]
      )
    end

    it 'creates a new record when entry is not already in the database' do
      described_class.civic_api_to_representative_params(@rep_info)
      expect(described_class.count).to eq(1)
    end

    it 'does not create duplicate records when entry is already in the database' do
      described_class.create!({ name:  'Adam Smith', ocdid:  'ocdidtest',
      title: 'Representative' })
      #can add more about equality to make sure fields are the same for Adam Smith
      described_class.civic_api_to_representative_params(@rep_info)
      expect(described_class.count).to eq(1)
    end
  end
end