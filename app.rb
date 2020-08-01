require 'dotenv/load'
require File.dirname(__FILE__) + '/app/bot_client'
RACK_ENV = 'test'.freeze unless defined?(RACK_ENV)
API_KEY = 'altojardin'.freeze unless defined?(API_KEY)

BotClient.new.start
