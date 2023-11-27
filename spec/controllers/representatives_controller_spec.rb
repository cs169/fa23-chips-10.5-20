# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  before do
    @representatives = []
    3.times do |i|
      @representatives << Representative.create!(
        name:      "Representative #{i}",
        title:     "Title #{i}",
        address:   "Address #{i}",
        city:      "City #{i}",
        state:     "State #{i}",
        zip:       "Zip #{i}",
        party:     "Party #{i}",
        photo_url: "https://example.com/photo#{i}.jpg"
      )
    end
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @representatives' do
      get :index
      expect(assigns(:representatives)).to match_array(@representatives)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: @representatives.first.id }
      expect(response).to be_successful
    end

    it 'assigns @representative' do
      get :show, params: { id: @representatives.first.id }
      expect(assigns(:representative)).to eq(@representatives.first)
    end

    it 'renders the show template' do
      get :show, params: { id: @representatives.first.id }
      expect(response).to render_template('show')
    end

    context 'with an invalid representative ID' do
      it 'raises a record not found error' do
        expect do
          get :show, params: { id: 9999 } # Assuming no record with this ID
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
