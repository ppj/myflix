class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process resize_to_fill: [665, 375]
end
