# frozen_string_literal: true

require 'csv'
require 'json'
require_relative 'models/all'

def lambda_handler(event:, context:) # rubocop:disable Lint/UnusedMethodArgument
  output = CSV.generate do |csv|
    csv << Product::FB_HEADERS
    Product.with_type.each do |product|
      csv << Product::FB_HEADERS.map do |header|
        method = product.respond_to?("fb_#{header}") ? "fb_#{header}" : header
        product.send(method)
      end
    end
  end

  {
    statusCode: 200,
    body: output,
    headers: {
      'Content-Type' => 'application/CSV',
    },
  }
end
