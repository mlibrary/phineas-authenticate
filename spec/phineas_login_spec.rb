require "phineas_login"
require "rspec"
require "rack/test"

RSpec.describe "My App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response).to match(/hello/i)
  end
end
