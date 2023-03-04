class Publication
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'publications'

  embedded_in :product
  belongs_to :channel

  field :status, type: String
  field :options, type: Hash
  field :last_sync_at, type: Time, default: Time.at(0)
end