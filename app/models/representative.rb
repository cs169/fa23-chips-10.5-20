# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all
  DEFAULT_PHOTO_URL = 'https://s2.loli.net/2023/11/27/GWEmsx8PqJ5UayV.png'

  class << self
    def civic_api_to_representative_params(rep_info)
      rep_info.officials.each_with_index.map do |official, index|
        process_official(official, index, rep_info)
      end
    end

    def process_official(official, index, rep_info)
      title, ocdid = find_title_and_ocdid(rep_info, index)
      rep = find_or_initialize_rep(official, ocdid)
      update_rep(rep, official, title)
      rep
    end

    def find_title_and_ocdid(rep_info, index)
      title = ''
      ocdid = ''
      rep_info.offices.each do |office|
        next unless office.official_indices.include?(index)

        title = office.name
        ocdid = office.division_id
        break
      end
      [title, ocdid]
    end

    def find_or_initialize_rep(official, ocdid)
      Representative.find_or_initialize_by(name: official.name, ocdid: ocdid)
    end

    def update_rep(rep, official, title)
      address = official.address&.first
      photo_url = official.photo_url.presence || DEFAULT_PHOTO_URL
      party = official.party

      rep.assign_attributes(
        title:     title,
        address:   address&.line1,
        city:      address&.city,
        state:     address&.state,
        zip:       address&.zip,
        party:     party,
        photo_url: photo_url
      )
      rep.save if rep.changed?
    end
  end
end
