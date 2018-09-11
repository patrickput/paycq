require "airborne"

# Set default location
Airborne.configure do |config|
  config.base_url = 'https://api.github.com'
  config.headers = {:params => {:access_token => '03ab86f06917e4ce74dbbaaf37e369488bd28345'}}
end