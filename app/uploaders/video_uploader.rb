class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer

  version :thumb do
    process thumbnail: [{format: 'png', size: 317, strip: true}]
    def full_filename for_file
      png_name for_file, version_name
    end
  end

  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end

  process encode_video: [:mp4]
  process :save_video_duration

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mp4 do
    process encode_video: [:mp4]
  end

  version :mov do
    process encode_video: [:mov]
  end

  def save_video_duration
    video = FFMPEG::Movie.new(file.file).duration
    model.video_duration = video
  end
end