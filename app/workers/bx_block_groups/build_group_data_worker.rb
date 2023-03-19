module BxBlockGroups
  class BuildGroupDataWorker
    include Sidekiq::Worker

    def perform(migration = true)
      if migration
        BxBlockCategories::Groups.call
        AccountBlock::GroupCreation.call
      else
        BxBlockCategories::Groups.call
      end
    end
  end
end
