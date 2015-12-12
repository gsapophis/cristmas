class FeedbackVideoUploader < VideoUploader
  def save_video_duration
    video = FFMPEG::Movie.new(file.file).duration
    model.feedback_video_duration = video
  end
end