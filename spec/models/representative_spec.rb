# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe 'civic_api_to_representative_params' do
    let(:rep_info) do
      OpenStruct.new(
        officials: [
          OpenStruct.new(
            name:      'Adam Smith',
            address:   [
              OpenStruct.new(
                line1: '123 Main St',
                city:  'Anytown',
                state: 'AT',
                zip:   '12345'
              )
            ],
            photo_url: nil, # No photo URL provided
            party:     'Independent'
          )
        ],
        offices:   [
          OpenStruct.new(
            name:             'Representatives',
            division_id:      'ocdidtest',
            official_indices: [0]
          )
        ]
      )
    end

    context 'when entry is not already in the database' do
      it 'creates a new record' do
        expect do
          described_class.civic_api_to_representative_params(rep_info)
        end.to change(described_class, :count).by(1)
      end

      it 'sets default photo url when photo_url is not provided' do
        described_class.civic_api_to_representative_params(rep_info)
        rep = described_class.last
        expect(rep.photo_url).to eq(described_class::DEFAULT_PHOTO_URL)
      end
    end

    context 'when entry is already in the database' do
      before do
        described_class.create!(name: 'Adam Smith', ocdid: 'ocdidtest', title: 'Representative')
      end

      it 'does not create duplicate records' do
        expect do
          described_class.civic_api_to_representative_params(rep_info)
        end.not_to change(described_class, :count)
      end

      it 'updates existing record with new information' do
        described_class.civic_api_to_representative_params(rep_info)
        rep = described_class.find_by(name: 'Adam Smith')
        expect(rep.address).to eq('123 Main St')
        expect(rep.city).to eq('Anytown')
        # Test other fields as needed
      end
    end
  end
end
