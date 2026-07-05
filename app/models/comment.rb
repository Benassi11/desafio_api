# frozen_string_literal: true

class Comment < ApplicationRecord
  # belongs_to
  belongs_to :task
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true

  # has_many
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', inverse_of: :parent, dependent: :destroy

  # validates

  validates :description, presence: true
end
