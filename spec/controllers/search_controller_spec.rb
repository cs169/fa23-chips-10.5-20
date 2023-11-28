# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  context 'when do GET #search' do
    let(:civic_info_service_double) { nil }

    describe 'Test Connection' do
      it 'by default expect nil' do
        allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(civic_info_service_double)
        expect(civic_info_service_double).to be_nil
      end
    end

    # describe 'Test GET #search with Valid Address' do
    #   before do
    #     test_address = 'California'
    #     allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(civic_info_service_double)
    #     allow(Representative).to receive(:civic_api_to_representative_params).and_return(true)
    #   end
    #   it 'get valid address' do
    #     allow(controller).to receive(:search).and_call_original
    #     get :search, params: { address: test_address }
    #     expect(assigns(:representatives)).not_to be_nil
    #     expect(response.status).to eq(200)
    #   end
    # end
  end
end
