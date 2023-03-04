class ProductImageUploader < CarrierWave::Uploader::Base
  storage :file
  
  def store_dir
    "tmp/#{model.class.to_s.underscore}"
  end

end
