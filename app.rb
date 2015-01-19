$: << File.join(File.dirname(__FILE__), 'lib')

require 'sinatra'
require 'sinatra/cross_origin'
require 'mac_address_db'

configure do
  enable :cross_origin

  # @TODO(joe): setting the db on the global config object smells funny.
  set :db, MacAddressDB.new
  Dir['db/**'].each do |f|
    settings.db.load_data(f)
  end
end


# routes

get '/' do
  content_type 'text/plain'
  base_url = request.env['rack.url_scheme'] + '://' + request.env['HTTP_HOST']
  body <<-EOF
MAC address vendor lookup service.

Examples:

curl #{base_url}/00:11:22:33:44:55
curl #{base_url}/001122334455

Source: https://github.com/joemiller/mac-to-vendor
  EOF
end

get '/:mac' do
  content_type 'text/plain'
  mac = params[:mac]

  if mac.length > 17 or mac.length < 2
    halt 400, 'invalid mac address'
  end

  vendor = settings.db.lookup(mac)
  if vendor.nil?
    vendor = 'unknown'
  end
  body "#{vendor}\n"
end
