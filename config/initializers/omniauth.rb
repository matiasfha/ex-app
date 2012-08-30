Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '374295515926917', 'c79528011ea1de9413185ef0333a69ab'
  provider :twitter, 'dTMGX2ISNeEE7Sy5r1iedA', 'TdbDYXm6NF5PA7l6vGoQXQjZFr3uoqKEUklVuqKiieU'
end