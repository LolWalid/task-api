CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = true
  config.asset_host = ActionController::Base.asset_host
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end
