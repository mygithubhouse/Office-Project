class BuildGroups < ActiveRecord::Migration[6.0]
  def change
    BxBlockGroups::BuildGroupDataWorker.perform_async(true)
  end
end
