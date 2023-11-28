# spec/controllers/map_controller_spec.rb
require 'rails_helper'

RSpec.describe MapController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @states and @states_by_fips_code' do
      states = [State.create!(name: 'California', symbol: 'CA', fips_code: 6, is_territory: 0, lat_min: 0, lat_max: 0, long_min: 0, long_max: 0)]
      get :index
      expect(assigns(:states)).to match_array(states)
      expect(assigns(:states_by_fips_code)).to eq(states.index_by(&:std_fips_code))
    end
  end

  describe 'GET #state' do
    context 'when state exists' do
      let!(:state) { State.create!(name: 'California', symbol: 'CA', fips_code: 6, is_territory: 0, lat_min: 0, lat_max: 0, long_min: 0, long_max: 0) }

      it 'assigns @state and renders the state template' do
        get :state, params: { state_symbol: state.symbol }
        expect(assigns(:state)).to eq(state)
        expect(response).to render_template(:state)
      end
    end

    context 'when state does not exist' do
      it 'redirects to root_path with an alert' do
        get :state, params: { state_symbol: 'nonexistent' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("State 'NONEXISTENT' not found.")
      end
    end
  end

  describe 'GET #county' do
    let!(:state) { State.create!(name: 'California', symbol: 'CA', fips_code: 6, is_territory: 0, lat_min: 0, lat_max: 0, long_min: 0, long_max: 0) }
    let!(:county) { County.create!(name: 'Los Angeles', state: state, fips_code: 6037, fips_class: 'H1') }

    context 'when state and county exist' do
      it 'assigns @county and renders the county template' do
        get :county, params: { state_symbol: state.symbol, std_fips_code: county.fips_code }
        expect(assigns(:county)).to eq(county)
        expect(response).to render_template(:county)
      end
    end

    context 'when state does not exist' do
      it 'redirects to root_path with an alert' do
        get :county, params: { state_symbol: 'nonexistent', std_fips_code: county.fips_code }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("State 'NONEXISTENT' not found.")
      end
    end

    context 'when county does not exist' do
      it 'redirects to root_path with an alert' do
        get :county, params: { state_symbol: state.symbol, std_fips_code: 'nonexistent' }
        expect(flash[:alert]).to be_nil
      end
    end
  end
end
