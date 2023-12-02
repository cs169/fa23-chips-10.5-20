# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  # List of valid issues
  ISSUES = [
    'Free Speech', 'Immigration', 'Terrorism', 'Social Security and Medicare',
    'Abortion', 'Student Loans', 'Gun Control', 'Unemployment',
    'Climate Change', 'Homelessness', 'Racism', 'Tax Reform',
    'Net Neutrality', 'Religious Freedom', 'Border Security',
    'Minimum Wage', 'Equal Pay'
  ].freeze

  # Validations
  validates :issue, inclusion: { in: ISSUES, message: '%<value>s is not a valid issue' }

  def self.find_for(representative_id)
    NewsItem.find_by(representative_id: representative_id)
  end
end
