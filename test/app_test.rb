require 'test_helper'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe 'MacToVendor' do

  it 'should return a short introduction on the root route' do
    get '/'
    _(last_response.status).must_equal 200
    _(last_response.body).must_include 'MAC address vendor lookup service'
  end

  it 'returns a vendor string for a known MAC address' do
    get '/52:54:00:11:22:aa'
    _(last_response.status).must_equal 200
    _(last_response.body.chomp).must_equal 'QEMU Virtual NIC'
  end

  it 'returns unknown for unknown MAC address' do
    get '/bb:aa:cc:dd:ee:ff'
    _(last_response.status).must_equal 200
    _(last_response.body.chomp).must_equal 'unknown'
  end

  it 'returns 400 if MAC address param is not valid because it is too long' do
    get '/00:11:22:33:44:55:66:77:88'
    _(last_response.status).must_equal 400
    _(last_response.body.chomp).must_equal 'invalid mac address'
  end

  it 'returns 400 if MAC address param is not valid because it is too short' do
    get '/0'
    _(last_response.status).must_equal 400
    _(last_response.body.chomp).must_equal 'invalid mac address'
  end

end
