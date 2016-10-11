if !Rails.env.test?
  def sendgrid_configured?
    ENV["SENDGRID_USERNAME"].present? &&
      ENV["SENDGRID_PASSWORD"].present?
  end

  if sendgrid_configured?
    ActionMailer::Base.smtp_settings = {
      address:              'smtp.sendgrid.net',
      port:                 '587',
      authentication:       :plain,
      user_name:            ENV.fetch('SENDGRID_USERNAME'),
      password:             ENV.fetch('SENDGRID_PASSWORD'),
      domain:               'heroku.com',
      enable_starttls_auto: true
    }
    ActionMailer::Base.delivery_method = :smtp
  else
    Rails.logger.info { "Sendgrid environment variables not set. Transactional emails will not be sent."}
  end

  def mandrill_configured?
    ENV["MANDRILL_USERNAME"].present? &&
    ENV["MANDRILL_API_KEY"].present? &&
    ENV["MANDRILL_DOMAIN"].present?
  end

  if mandrill_configured?
    require 'yaml'

    ActionMailer::Base.smtp_settings = {
      address:   "smtp.mandrillapp.com",
      port:      587,
      user_name: ENV["MANDRILL_USERNAME"],
      password:  ENV["MANDRILL_API_KEY"],
      domain:    ENV["MANDRILL_DOMAIN"]
    }
    ActionMailer::Base.delivery_method = :smtp

    MandrillMailer.configure do |config|
      config.api_key = ENV["MANDRILL_API_KEY"]
    end
  else
    Rails.logger.info { "Mandrill environment variables not set. Transactional emails will not be sent."}
  end
end
