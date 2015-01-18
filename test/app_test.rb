require 'test_helper'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe 'MacToVendor' do

  it 'should return a short introduction on the root route' do
    get '/'
    last_response.status.must_equal 200
    last_response.body.must_include 'MAC Address vendor lookup service'
  end

  it 'returns a vendor string for a known MAC address' do
    get '/52:54:00:11:22:aa'
    last_response.status.must_equal 200
    last_response.body.chomp.must_equal 'QEMU'
  end

  it 'returns a 404 for unknown MAC address' do
    get '/bb:aa:cc:dd:ee:ff'
    last_response.status.must_equal 404
    last_response.body.chomp.must_equal 'unknown'
  end

  it 'returns 400 if MAC address param is not valid because it is too long' do
    get '/00:11:22:33:44:55:66:77:88'
    last_response.status.must_equal 400
    last_response.body.chomp.must_equal 'invalid mac address'
  end

  it 'returns 400 if MAC address param is not valid because it is too short' do
    get '/0'
    last_response.status.must_equal 400
    last_response.body.chomp.must_equal 'invalid mac address'
  end

end
