module BxBlockCustomAd
  class CustomAdsExpireWorker
    include Sidekiq::Worker

    def perform(*args)
      BxBlockCustomAds::CustomAd.where(" DATE(end_date) < ? AND status = ? ", Date.current, true).each{|c|c.update(status: false)}
      BxBlockCustomAds::CustomAd.where(" DATE(start_date) >= ? AND DATE(end_date) < ? AND status = ?", Date.current, Date.current, false).each{ |c| c.update(status: true)}
    end
  end
end

# Sidekiq::Cron::Job.create(name: 'hard worker', cron: '*/5 * * * *', class: 'BxBlockCustomAd::CustomAdsExpireWorker')
