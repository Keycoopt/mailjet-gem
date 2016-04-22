#minitest
require 'minitest/autorun'
require 'minitest/matchers'
require 'minitest/pride'
require 'minitest-spec-context'
require 'mocha/setup'
require 'mailjet'
require 'mailjet/resource'

require File.expand_path './support/vcr_setup.rb', __dir__

test_account = YAML::load(File.new(File.expand_path("../../config.yml", __FILE__)))['mailjet']

Mailjet.configure do |config|
  configuration_values = { "api_key" => ENV['MJ_APIKEY_PUBLIC'], "secret_key" => ENV['MJ_APIKEY_PRIVATE'], "default_from" => ENV['gbadi@student.42.fr'], "end_point" => nil }
	if configuration_file = File.expand_path("../../config.yml", __FILE__)
    configuration_values.merge!(YAML::load_file(configuration_file)['mailjet'])
  end
  
  config.api_key = configuration_values['api_key']
  config.secret_key = configuration_values['secret_key']
  config.default_from = configuration_values['default_from']
  config.end_point = configuration_values['end_point']
end
