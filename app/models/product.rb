class Product
    include Mongoid::Document
    include Mongoid::Timestamps
    
    store_in collection: "products"
    
    field :sku, type: String
    field :remote_id, type: String
    field :content, type: Hash
    field :last_sync, type: DateTime, default: Time.at(0)
    field :versions, type: Array, default: []
    field :extra_information, type: Hash, default: {}

    field :name, type: String
    mount_uploaders :images, ProductImageUploader

    index({last_sync: 1}, {background: true})
    index({remote_id: 1}, {background: true})
    index({sku: 1}, {background: true})
    index({"content.name": 1}, {background: true})
    index({"content.name": 1, sku: 1}, {background: true})
    index({"content.categories.id": 1}, {background: true})
    index({"content.tags.name": 1}, {background: true})
    index({"content.attributes.name": 1, "content.attributes.options": 1}, {background: true})
    index({"versions.collection_id": 1, "versions.version": 1}, {background: true})
    index({"versions": 1}, {background: true})
  end
