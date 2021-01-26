# frozen_string_literal: true

require 'airrecord'
require 'dotenv/load'

require_relative 'product'

Airrecord.api_key = ENV['AIRTABLE_API_KEY']
