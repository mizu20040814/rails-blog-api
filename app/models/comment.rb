class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :likes, dependent: :destroy

  validates :body, presence: true
end
