class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_enumeration_for :status, with: TaskStatus, create_helpers: true
  has_many_attached :attachments

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :user, presence: true
end
