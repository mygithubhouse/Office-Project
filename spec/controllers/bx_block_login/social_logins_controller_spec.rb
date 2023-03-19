require 'rails_helper'
require 'webmock/rspec'

RSpec.describe BxBlockLogin::SocialLoginsController, type: :controller do
  let(:token) { "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQzN2FhNTA0MzgxMjkzN2ZlNDM5NjBjYTNjZjBlMjI4NGI2ZmMzNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjQ5NTkyMDMwNDk3LWdwM21vcWgwazJzcmM1cjJ1NXFmYW9yaWkxZHFrdmRjLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjQ5NTkyMDMwNDk3LWdwM21vcWgwazJzcmM1cjJ1NXFmYW9yaWkxZHFrdmRjLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTA4NzQ5NzQ1MTgyNTA4NTg2NDYzIiwiZW1haWwiOiJ5YXNobXRocjY1QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiTmIteWJRaE9IenlMUXFPQ0N5QmFFUSIsIm5hbWUiOiJZYXNoIE1hdGh1ciIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BRWRGVHA1UDVFbFdqcWNha0g2bHNnZnNCc1ZvRnZwLUJFZ2JudVRzZVNLOEZ6Yz1zOTYtYyIsImdpdmVuX25hbWUiOiJZYXNoIiwiZmFtaWx5X25hbWUiOiJNYXRodXIiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY3Mzg3OTA3NiwiZXhwIjoxNjczODgyNjc2LCJqdGkiOiIwM2UzM2YxZGZjNjczYTQwYWIyMTI4NDI0M2RiZTI5Y2IyMzRmM2Q2In0.ABPLdumT4ZTzcYqesU4wuMhOrsacTIiJpoZD5AxnsxFgSKzQjTVU7kcxI3WgMq9My9fcGQFJ7OhjNNfRKdB0iQ0z0nMB0gtgEYjfPlNIYWlF8fA6ow6zxeqpQLNfmv0D1_G8CDgg43VuX5YPM_l9qWWsQf4pBabVwvzbUsaWOdXLOSStoy5J5vv_V-XgstgMOGXuJtK8cSoc-nqK6X5MeS-WpjAoKxl-ovQWk-NVS6kp67WMA-_E7Me_IBOTooboQhBGEgaTJUtHG95GLj60Z2szeKxKLYVvDbtMAsw-asCIzkJ9R7l7almK2N3LiN8s1hinHdp0rNv0VrCKAfCcLQ" }

  let(:base_url) { "https://www.googleapis.com/oauth2/v3/tokeninfo" }
  let(:login_payload) do
    {
    'token' => token
    }
  end
  let(:request_payload) do
    {
    'id_token' => token
    }
  end
  let(:response_body) do
    {
      'error_description' => "invalid Value"
    }
  end
  let(:response_header) do
    {
    "expires"=>["Mon, 01 Jan 1990 00:00:00 GMT"], "date"=>["Thu, 19 Jan 2023 04:56:31 GMT"], "pragma"=>["no-cache"], "cache-control"=>["no-cache, no-store, max-age=0, must-revalidate"], "content-type"=>["application/json; charset=UTF-8"], "vary"=>["Origin", "X-Origin", "Referer"], "server"=>["ESF"], "x-xss-protection"=>["0"], "x-frame-options"=>["SAMEORIGIN"], "x-content-type-options"=>["nosniff"], "alt-svc"=>["h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""], "connection"=>["close"], "transfer-encoding"=>["chunked"]
    }
  end
  
  describe 'POST get_authorization' do
     it 'sends a get request to the Google' do
      stub_request(:get, base_url).with(body: request_payload).to_return( body: response_body.to_json, status: 200, headers: response_header)
    end
  end
end