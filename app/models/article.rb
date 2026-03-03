class Article < ApplicationRecord
  enum :status, { draft: 0, published: 1 }
  validates :title, presence: true
  scope :published, -> { where(status: :published) }
end
