class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer

  version :thumb do
    process thumbnail: [{format: 'png', quality: 10, size: 192, strip: true}]
    def full_filename for_file
      png_name for_file, version_name
    end
  end

  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end

  process encode_video: [:mp4]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mp4 do
    process :encode_video => [:mp4]
  end

  # version :ogv, :from_version => :mp4 do
  #   process :encode_ogv => [{ callbacks: { after_transcode: :set_success }  }]
  # end
  #
  # version :ogg, :from_version => :mp4 do
  #   process :encode_ogv => [{ callbacks: { after_transcode: :set_success } }]
  # end
end