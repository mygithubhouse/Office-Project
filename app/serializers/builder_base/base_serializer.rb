module BuilderBase
  class BaseSerializer
    include FastJsonapi::ObjectSerializer

    class << self
      private

      def base_url
         Rails.env.production? ? ENV['BASE_URL'] : 'http://localhost:3000'
       end


      def get_image_url(object)
      class_name =  object.class.name.split("::").last
        object&.image&.attached? ? base_url + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) : nil
      end

      def get_video_url(object)
        object.video.attached? ? base_url + Rails.application.routes.url_helpers.rails_blob_url(object.video, only_path: true) : nil
      end
    
    end
  end
end
