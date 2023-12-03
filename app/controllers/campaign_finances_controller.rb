# frozen_string_literal: true

class CampaignFinancesController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    # This action will just render the search form
  end

  def display
    cycle = params[:cycle]
    category = params[:category]

    if cycle.present? && category.present?
      url = URI("https://api.propublica.org/campaign-finance/v1/#{cycle}/candidates/leaders/#{category}.json")
      response = fetch_finance_data(url)

      if response.is_a?(Net::HTTPSuccess)
        finance_data = JSON.parse(response.body)['results']
        # byebug
        @finance_records = FinanceRecord.process_finance_data(finance_data)
      else
        @finance_records = []
        flash.now[:error] = 'Error fetching finance data'
      end
    else
      @finance_records = []
    end

    render 'campaign_finances/display'
  end

  private

  def fetch_finance_data(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['X-API-Key'] = propublica_api_key

    http.request(request)
  end

  def propublica_api_key
    if Rails.env.production?
      Rails.application.credentials.production[:ProPublica_KEY]
    else
      Rails.application.credentials.development[:ProPublica_KEY]
    end
  end
end
