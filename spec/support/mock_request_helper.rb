require 'webmock/rspec'

module MockRequestHelper
  def mock_api_call(url, method_type, response_body)
    stub_request(method_type, url).to_return(body: response_body.to_json, status: 200)
  end
end
