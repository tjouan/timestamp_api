require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "webmock/rspec"
WebMock.disable_net_connect! allow: %w{codeclimate.com}

require "pry"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "timestamp_api"
