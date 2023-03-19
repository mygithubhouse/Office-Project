module BxBlockShare
  class Share < BxBlockShare::ApplicationRecord
    self.table_name = :share_records

    belongs_to :account, class_name: 'AccountBlock::Account'
    belongs_to :shared_to, class_name: 'AccountBlock::Account'
    belongs_to :post, class_name: 'BxBlockPosts::Post', optional: true

    has_many_attached :documents, dependent: :destroy

    def upload_documents(documents_params)
      documents_to_attach = []

      documents_params.each do |document_data|
        if document_data[:data]
          decoded_data = Base64.decode64(document_data[:data])
          documents_to_attach.push(
            io: StringIO.new(decoded_data),
            content_type: document_data[:content_type],
            filename: document_data[:filename]
          )
        end
      end

      self.documents.attach(documents_to_attach) unless documents_to_attach.empty?
    end
  end
end
