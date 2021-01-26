# frozen_string_literal: true

require 'redcarpet'
require 'redcarpet/render_strip'

class Product < Airrecord::Table
  self.base_key = ENV['AIRTABLE_BASE_ID']
  self.table_name = 'Producto'

  FB_HEADERS = %w[id title description availability condition price link image_link brand].freeze

  def self.with_type
    # excluye las pinturas/pinceles, que no tienen tipo
    all(filter: '{Tipo} != ""')
  end

  def name
    self['Name']
  end

  def fb_title
    name
  end

  def description
    self['Descripción']
  end

  def fb_description
    sanitizer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    # Redcarpet has a bug with multiple new lines inside code block
    # and also adds newline at the end...
    # TODO: fix redcarpet or find other lib
    sanitizer.render(description.delete("\n")).delete("\n")
  end

  def stock
    self['Stock']
  end

  def availability
    stock.positive? ? 'in stock' : 'available for order'
  end

  def condition
    'new'
  end

  def sale_price
    self['Precio de venta']
  end

  def fb_price
    "#{sale_price} PEN"
  end

  def fb_link
    'https://laultimapieza.com'
  end

  def image
    self['Image']
  end

  def fb_image_link
    image.dig(0, 'url')
  end

  def brand
    self['Marca']
  end
end
