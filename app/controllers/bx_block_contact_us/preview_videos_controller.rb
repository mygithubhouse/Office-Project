module BxBlockContactUs
  class PreviewVideosController < ApplicationController
    def index
      previews = BxBlockContactUs::PreviewVideo.first
      render json: PreviewVideoSerializer.new(previews).serializable_hash, status: :ok
    end
  end
end
