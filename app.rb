require 'dotenv/load'
require File.dirname(__FILE__) + '/app/bot_client'
RACK_ENV = 'test'.freeze unless defined?(RACK_ENV)

BotClient.new.start
