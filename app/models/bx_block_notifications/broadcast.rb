module BxBlockNotifications
  class Broadcast < ApplicationRecord
    include SidekiqHelper

    self.table_name = :broadcasts
    before_destroy :delete_sidekiq_job

    private

    def delete_sidekiq_job
      if job_executed?
        errors.add(:scheduled_date, 'Already executed')
        throw(:abort)
      else
        delete_job(jid)
       end
    end

    def job_executed?
      Time.now >= scheduled_date
    end
  end
end
