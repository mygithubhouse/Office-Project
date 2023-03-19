FactoryBot.define do
  factory :custom_ad, :class => 'BxBlockCustomAds::CustomAd' do    
    message {'text123'}
    link {'text123'}
    click_count {1}
    view_count {1}
    status {true}
    title {'text123'}
    start_date { Time.now }
    end_date { Time.now }

  end
end
