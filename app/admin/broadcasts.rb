ActiveAdmin.register BxBlockNotifications::Broadcast, as: 'Broadcast List' do
  config.filters = false
  actions :all, except: [:edit, :new, :show]

  index do
    column :message
    column :scheduled_date
    column :scheduled_on do |obj|
      obj.created_at
    end
    column :jid
    actions
  end
end



