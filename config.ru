require 'rubygems'
require 'bundler'
Bundler.require

HoptoadNotifier.configure do |config|
  config.api_key = 'asdfasdf'
end

require 'init'
run Interpres::Init.new