class Task < ApplicationRecord
  belongs_to :user
  has_many :comment
  has_enumeration_for :status, with: TaskStatus, create_helpers: true
end
