module SeedData
  class GroupData
    class << self
      def call
        BxBlockGroups::BuildGroupDataWorker.perform_async(false)
      end
    end
  end
end
