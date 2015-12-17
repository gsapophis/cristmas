require 'mini_exiftool'
class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer

  version :thumb do
    process thumbnail: [{format: 'jpg', size: 317, strip: true}]
    def full_filename for_file
      jpg_name for_file, version_name
    end
  end

  version :share_thumb do
    process thumbnail: [{format: 'jpg', size: 600}]
    def full_filename for_file
      jpg_name for_file, version_name
    end
  end

  def jpg_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.jpg}
  end

  # process encode_video: [:mp4]
  # process :save_video_duration

  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :encode

  version :mp4 do
    process encode_video: [:mp4, resolution: :same]
    process :save_video_duration
  end

  def encode
    video = MiniExiftool.new(@file.path)
    orientation = video.rotation

    if orientation == 90
      encode_video(:mp4, resolution: "200x300")
    else
      encode_video(:mp4)
    end
  end


  # watermark: {
  #     path: File.join(Rails.root, "app/assets/images", "logo.png"),
  #     position: :top_right#, # also: :top_right, :bottom_left, :bottom_right
  #     # pixels_from_edge: 10
  # }
  # version :mov do
    # process encode_video: [:mov]
  # end

  def save_video_duration
    video = FFMPEG::Movie.new(file.file).duration
    model.video_duration = video
  end
end