class McpType < ApplicationRecord
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
