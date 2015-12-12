# encoding: utf-8

class AvatarUploader < BaseUploader
  version :avatar do
    process resize_to_limit: [69, -1]
  end
end
