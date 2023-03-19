module BxBlockShare
  class ShareSerializer < BuilderBase::BaseSerializer
    attributes :id, :account_id, :shared_to_id, :post_id, :created_at, :updated_at

    attribute :documents do |object|
      object.documents.attached? ?
        object.documents.map { |doc|
          {
            id: doc.id, filename: doc.filename,
            url: Rails.application.routes.url_helpers.url_for(doc),
            type: doc.blob.content_type.split('/')[0]
          }
        } : []
    end
  end
end
