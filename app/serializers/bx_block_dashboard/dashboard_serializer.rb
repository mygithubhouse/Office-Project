module BxBlockDashboard
  class DashboardSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :value, :created_at, :updated_at
  end
end
