# encoding: utf-8
require 'carrierwave/processing/mini_magick'
class ImagenUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include ::CarrierWave::Backgrounder::Delay
  storage :fog
  
  process :set_content_type
  process :convert => 'png'

  def filename
    super.chomp(File.extname(super)) + '.png'
  end

# Create different versions of your uploaded files:
  
  
  version :thumb do
    process :resize => [32,32]
  end

  version :medium do 
    process :resize => [300,300]
  end

  version :large do 
    process :resize => [600,600]
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  def default_url
    asset_path("fallback/" + [version_name, "default-photo.png"].compact.join('_'))
  end


  protected

  def resize(width, height)
    manipulate! do |img|
      img.combine_options do |cmd|
        if img[:width] >= width && img[:height] <= height
          #Imagen mas ancha que alta
          cmd.thumbnail "#{width}"
          cmd.strip
          cmd.background "rgba(255, 255, 255, 0.0)"
          cmd.gravity "Center"
          cmd.extent "#{width}"
        else
          if img[:width] <= width && img[:height] >= height
            #Imagen mas alta que ancha
            cmd.thumbnail "x#{height}"
            cmd.strip
            cmd.background "rgba(255, 255, 255, 0.0)"
            cmd.gravity "Center"
            cmd.extent "x#{height}"
          else
            cmd.thumbnail "#{width}x#{height}>"
            cmd.strip
            cmd.background "rgba(255, 255, 255, 0.0)"
            cmd.gravity "Center"
            cmd.extent "#{width}x#{height}>"
          end
        end
      end
      img = yield(img) if block_given?
      img
    end
  end#end resize
  
end
