class Channel
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :publications

  field :name, type: String
  field :active, type: Boolean, default: true
  field :settings, type: Hash, default: {}
end