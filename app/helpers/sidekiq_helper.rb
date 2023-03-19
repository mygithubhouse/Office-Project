module SidekiqHelper
  def delete_job(jid)
    Sidekiq::ScheduledSet.new.find_job(jid).delete
  end
end
