ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'minitest/spec'
require 'minitest/autorun'

require_relative '../app.rb'