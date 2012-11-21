ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'dandoo.tv',
  :user_name            => ENV['SMTP_USER'],
  :password             => ENV['SMTP_PASSWORD'],
  :authentication       => 'plain',
  :enable_starttls_auto => true
}

