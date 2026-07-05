# frozen_string_literal: true

class Task < ApplicationRecord
  # belongs_to
  belongs_to :user

  # has_many
  has_many :comments, dependent: :destroy

  # enum
  has_enumeration_for :status, with: TaskStatus, create_helpers: true

  # has_many_attached
  has_many_attached :attachments

  # validates
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
end
