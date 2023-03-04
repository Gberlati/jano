class Product
    include Mongoid::Document
    include Mongoid::Timestamps
    
    store_in collection: "products"

    embeds_many :publications

    field :sku, type: String
    field :name, type: String, default: ''
    field :description, type: String, default: ''
    field :short_description, type: String, default: ''
    field :price, type: String, default: 0.00
    field :list_price, type: String, default: 0.00
    field :active, type: Boolean, default: true
    field :packages, type: Array, default: [] # { width, height, length, weight }
    field :tags, type: Array, default: []
    field :stock_type, type: String, default: 'numeric' # infinite, numeric
    field :stock_quantity, type: Integer, default: 0
    field :attributes, type: Array, default: [] # { name, values }
    field :variations, type: Array, default: [] # { sku, attributes, stock_type, stock_quantity }
    field :extra_information, type: Hash, default: {}

    mount_uploaders :images, ProductImageUploader

    index({sku: 1}, {background: true})
    index({sku: 1, name: 1}, {background: true})
    index({tags: 1}, {background: true})
    index({active: 1}, {background: true})
    
    index({stock_type: 1}, {background: true})
    index({stock_quantity: 1}, {background: true})
    
    index({'attributes.name': 1}, {background: true})
    index({'attributes.values': 1}, {background: true})
    index({'attributes.name': 1, 'attributes.values': 1}, {background: true})

    index({'variations.sku': 1}, {background: true})
    index({'variations.sku': 1, 'variations.attributes': 1}, {background: true})
    index({'variations.stock_type': 1}, {background: true})
    index({'variations_stock_quantity': 1}, {background: true})

    index({created_at: 1}, {background: true})
    index({updated_at: 1}, {background: true})
  end
