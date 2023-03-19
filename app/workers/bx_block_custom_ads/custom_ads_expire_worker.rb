module BxBlockCustomAds
  class CustomAdsExpireWorker
    include Sidekiq::Worker

    def perform(*args)
      expire_ads = BxBlockCustomAds::CustomAd.where("end_date < :time OR start_date > :time", time: Time.now.in_time_zone('UTC'))
      expire_ads.each{|c| c.update(status: false)} if expire_ads.present?
    end
  end
end

