class ImageUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  process resize_to_fit: [800, 800]

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{Digest::SHA1.file(file.file).hexdigest}.png" if original_filename
  end
end
