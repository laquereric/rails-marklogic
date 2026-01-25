class McpType < ApplicationRecord
  def domain_schema
    DomainKnowledge::Schema.parse(schema)
  end

  def computed_structural_hash
    domain_schema.structural_hash
  end

  validates :uri, presence: true, uniqueness: true
  validates :schema, presence: true
  validates :structural_hash, presence: true
  validates :version, presence: true
  validates :environment, presence: true

  scope :by_hash, ->(hash) { where(structural_hash: hash).order(version: :desc) }

  def self.latest_by_hash(hash)
    by_hash(hash).first
  end

  def immutable?
    persisted?
  end
end
