module BxBlockNotifsettings
  class NotificationSubgroup < BxBlockNotifsettings::ApplicationRecord
    include NotificationSettingsStates

    belongs_to :notification_group,
               class_name: 'BxBlockNotifsettings::NotificationGroup',
               foreign_key: 'notification_group_id'

    self.table_name = :notification_subgroups

    SUBGROUPS_TYPE = {
        wishlist_item_out_of_stock: 0,
        out_of_stock_notification: 1,
        new_order: 2,
        order_cancelled: 3,
        on_hold: 4,
        order_shipped: 5,
        order_delivered: 6,
        refunded: 7
    }.freeze

    enum state: STATES
    enum subgroup_type: SUBGROUPS_TYPE
  end
end
