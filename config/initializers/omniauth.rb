OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, '821036347944688', '3c11faa49822f1ade34694c039041e06', scope: "email"
  #provider :twitter,'qMt1n4SLKgbkO3MZ0AHowpdbk', 'ADHB8teZQW7erYvPgBsgfzYm02xcXustDqeWAEclD0F5qJAJXG', setup: true
end