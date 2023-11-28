# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def test_email
    mail(to: 'test@example.com', subject: 'Test Email', body: 'This is a test')
  end
end
