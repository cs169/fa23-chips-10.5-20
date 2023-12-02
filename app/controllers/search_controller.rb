# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class SearchController < ApplicationController
  def search
    address = params[:address]
    service = Google::Apis::CivicinfoV2::CivicInfoService.new

    # Refactored to use conditional assignment
    service.key = if Rails.env.production?
                    Rails.application.credentials.production[:GOOGLE_API_KEY]
                  else
                    Rails.application.credentials.development[:GOOGLE_API_KEY]
                  end

    # Removed commented out code for clarity
    # byebug
    result = service.representative_info_by_address(address: address)
    @representatives = Representative.civic_api_to_representative_params(result)

    render 'representatives/search'
  end
end
