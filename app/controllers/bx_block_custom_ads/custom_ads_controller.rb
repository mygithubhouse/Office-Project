class BxBlockCustomAds::CustomAdsController < ApplicationController
  include BuilderJsonWebToken::JsonWebTokenValidation
  before_action :validate_json_web_token, only:[:create, :update, :index]
  skip_before_action :validate_json_web_token, only:[:index]
  before_action :check_admin_user, only: [:create, :update]
  before_action :load_ad, only: :update


  def index
    @custom_ads = BxBlockCustomAds::CustomAd.where(status: true)
    if @custom_ads.present?
      @custom_ads.where("start_date <= ?", Time.now).where("end_date >= ?", Time.now).update_all("view_count=view_count+1")
      render json: BxBlockCustomAds::CustomAdSerializer.new(@custom_ads).serializable_hash, status: :ok
    else
      render json: {data:[]}, status: :ok
    end
  end

  def create
    @custom_ad = BxBlockCustomAds::CustomAd.new(ads_params)
    if @custom_ad.save
      render json: BxBlockCustomAds::CustomAdSerializer.new(@custom_ad, params: { custom_ad: @custom_ad }).serializable_hash, status: 201
    else
      render json: { errors: "CustomAd can't be saved", errors: @custom_ad.errors }, status: 400
    end
  end

  def update
    if @ad.update(ads_params)
      render json: BxBlockCustomAds::CustomAdSerializer.new(@ad).serializable_hash
    else
      render json: { errors: @ad.errors }, status: 400
    end
  end

  def update_click_count
    @custom_ad = BxBlockCustomAds::CustomAd.find_by(id: params[:custom_ad_id])
    if @custom_ad
      @custom_ad_res =  @custom_ad.update(click_count: @custom_ad.click_count + 1)
      render json: {message: 'Click count updated successfully' }, status: :ok
      else
       render json: {message: "Custom Ads Not Found"}, status: 404
    end
  end

  private

  def load_ad
    @ad = BxBlockCustomAds::CustomAd.find_by(id: params[:id])
    render json: {error: "Couldn't find Ad with id #{params[:id]}" }, status: 404 unless @ad
  end

  def check_admin_user
    @current_user = AdminUser.find_by(id: @token.id)
    render json: { error: "Not Authorized" }, status: 401 unless @current_user
  end

  def ads_params
    params.require(:custom_ad).permit(:title, :start_date, :end_date, :status, :video, :image, :link, :message)
  end
end

