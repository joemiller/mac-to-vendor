require 'sinatra'
require 'sinatra/cross_origin'
require_relative 'mac_address_db'

# init and load db
configure do
  enable :cross_origin

  set :db, MacAddressDB.new
  Dir['db/**'].each do |f|
    settings.db.load_data(f)
  end
end


# routes
get '/' do
  body <<-EOF
    #{@foo} MAC Address vendor lookup service.
    Usage:
       /00:11:22:33:44:55
       /001122334455
  EOF
end

get '/:mac' do
  mac = params[:mac]

  if mac.length > 17 or mac.length < 2
    halt 400, 'invalid mac address'
  end

  vendor = settings.db.lookup(mac)
  if vendor
    status 200
    body vendor + "\n"
  else
    status 404
    body "unknown\n"
  end
end
