# frozen_string_literal: true

module BxBlockContactUs
  # This is PrivacyPolicies serializer for show response
  class PrivacyPolicySerializer < BuilderBase::BaseSerializer
    attributes(:start_date, :end_date, :description)

    attribute :description do |object|
      description_response =  object[:description].split(/[\r\n]+/)
      description_response.map do |a|
      ActionView::Base.full_sanitizer.sanitize(a)
      end   
    end

    attribute :start_date do |object|
    	month = "#{object[:start_date].strftime("%B")} to #{object[:end_date].strftime("%B")}"
    end

    attribute :end_date do |object|
    	year = object[:end_date].strftime("%Y")
    end
 

  end
end
