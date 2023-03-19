require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  post 'customjs/send_notifications'
  get '/healthcheck', to: proc { [200, {}, ['Ok']] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'admin/dashboard#index'
  mount Sidekiq::Web => '/sidekiq'
  mount Ckeditor::Engine => '/ckeditor'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :bx_block_categories do
    resources :questions, only: %i[index create show update destroy]
    resources :car_details, only: %i[index create show update destroy]
    resources :car_makes, only: [:index, :destroy]
    resources :car_models, only: [:index,:destroy]
    resources :car_years, only: [:index]
    get 'cars/dropdown_details', to: 'cars#dropdown_details'
    resources :categories, only: [:create,:index]
  end

  namespace :account_block do
    resources :accounts do
      collection do
        get '/email_confirmations/:id', to: 'accounts/email_confirmations#show'
        get '/check_user_name_validation', to: 'accounts#check_user_name_validation'
        get '/check_email_validation', to: 'accounts#check_email_validation'
        put '/accept_privacy_policy', to: 'accounts#accept_privacy_policy'
        put '/accept_term_and_condition', to: 'accounts#accept_term_and_condition'
      end
      member do
        put '/add_battery_percentage', to: 'accounts#add_battery_percentage'
        put '/late_battery_percentage', to: 'accounts#late_battery_percentage'
      end
    end
    resources :battery_percentages do
      collection do
        get '/late_charging_status', to: 'battery_percentages#late_charging_status'
      end
    end
  end

  namespace :bx_block_contact_us do
    resources :contacts
    resources :preview_videos
    resources :privacy_policies do
      collection do
        get '/terms_and_condition_list', to: 'privacy_policies#terms_and_condition_list'
        get '/term_and_condition_accepted_or_not', to: 'privacy_policies#term_and_condition_accepted_or_not'
        get '/privacy_policy_accepted_or_not', to: 'privacy_policies#privacy_policy_accepted_or_not'
      end
    end
  end

  namespace :bx_block_help_centre do
    resources :question_answer
  end

  namespace :bx_block_forgot_password do
    resources :otps, only: [:create]
    resources :otp_confirmations, only: [:create]
    resources :passwords, only: [:create]
  end
  get '/update_roles', to: 'bx_block_roles_permissions/roles#update_roles'

  namespace :bx_block_states_cities do
    get 'state_cities/countries', to: 'state_cities#countries'
    get 'state_cities/states', to: 'state_cities#states'
    get 'state_cities/cities', to: 'state_cities#cities'
    get 'state_cities/zipcode_validation', to: 'state_cities#zipcode_validation'
    get 'state_cities/seed_cities', to: 'state_cities#seed_cities'
  end

  namespace :bx_block_states_cities do
    get 'grid_type_updates', to: 'grid_type_updates#update_grid'
  end

  namespace :bx_block_login do
    resources :social_logins
    post '/get_authorization', to: 'social_logins#get_authorization'
  end

  namespace :bx_block_custom_ads do
    resources :custom_ads do
      get '/custom_ad', to: 'custom_ads#custom_ad'
      put '/update_click_count', to: 'custom_ads#update_click_count'
    end
  end

  namespace :bx_block_dashboard do
    resources :dashboards do
      collection do
        get '/dashboards', to: 'dashboards#weekly_data'
        get '/fleet_status', to: 'dashboards#fleet_status'
      end
    end
  end

  namespace :bx_block_notifications do
    resources :notifications do
      collection do
        post '/send_notification', to: 'notifications#send_notification'
      end
    end
  end

  namespace :bx_block_gamification do
    resources :user_badges,  only: [:index]
  end

  namespace :bx_block_notifsettings do
    resources :notification_reminder_settings, only: %i(create index)
  end

  namespace :bx_block_notifsettings do
    resources :vacation_mode_settings, only: %i(create index)
  end
  namespace :bx_block_notifsettings do
    resources :easy_modes, only: %i(create index)
  end
  namespace :bx_block_account_groups do
    resources :groups do
      member do
        post :join_group
        delete :leave_group
      end
    end
  end

  namespace :bx_block_posts do
    resources :posts do
      member do
        post :add_comment
        delete :delete_comment
      end
    end
  end
end
