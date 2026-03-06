class Article < ApplicationRecord
  enum :status, { draft: 0, published: 1 }

  has_many :comments, dependent: :destroy

  validates :title, presence: true

  scope :published, -> { where(status: :published) }
end
