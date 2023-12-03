# frozen_string_literal: true

# spec/controllers/campaign_finances_controller_spec.rb

require 'rails_helper'

RSpec.describe CampaignFinancesController, type: :controller do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET display' do
    context 'with valid parameters' do
      it 'renders the display template with fetched data' do
        allow(FinanceRecord).to receive(:process_finance_data).and_return([FinanceRecord.new])
        get :display, params: { cycle: '2020', category: 'candidate-loan' }
        expect(assigns(:finance_records)).not_to be_empty
        expect(response).to render_template(:display)
      end
    end

    context 'with invalid or missing parameters' do
      it 'renders the display template with an empty dataset' do
        get :display
        expect(assigns(:finance_records)).to be_empty
        expect(response).to render_template(:display)
      end
    end
  end
end
