require 'rails_helper'      
RSpec.describe BxBlockContactUs::PreviewVideo, type: :model do

  subject {BxBlockContactUs::PreviewVideo.new(video_url: "https://test@gmail.com")}
    it { is_expected.to validate_presence_of(:video_url) }
end

